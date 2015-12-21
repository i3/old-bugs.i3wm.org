#!/usr/bin/env python
#coding=utf8


import sys
import json
import time
import datetime

import psutil


def i3bar_json(updates):
    sys.stdout.write('{ "version": 1 }\n[\n[]\n')
    sys.stdout.flush()
    for update in updates:
        sys.stdout.write(',%s\n' % json.dumps(update))
        sys.stdout.flush()
    sys.stdout.write(']')


class Block(object):

    """ A block displayed in the i3bar
    """

    def __init__(self, text, color=None, min_width=0, align='left'):
        self.text = text
        self.color = color
        self.align = align
        self.min_width = min_width

    def to_dict(self, name=None, instance=None):
        block = {'full_text': self.text, 'min_width': self.min_width,
                 'align': self.align}
        if self.color is not None:
            block['color'] = self.color
        if name is not None:
            block['name'] = name
        if instance is not None:
            block['instance'] = instance
        return block


def render_lines(blocks_functions, interval=1):
    while True:
        line = []
        for block_func in blocks_functions:
            result = block_func()
            if isinstance(result, Block):
                result = [result]
            for block in result:
                line.append(block.to_dict())

        yield line
        time.sleep(interval)


def clock(format='%a %b %d, %H:%M', color='#EEEEEE'):
    def _clock():
        now = datetime.datetime.now()
        text = now.strftime(format)
        return Block(text, color=color, min_width=200, align='center')
    return _clock


suffixes = {
    'decimal': ('kB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB'),
    'binary': ('KiB', 'MiB', 'GiB', 'TiB', 'PiB', 'EiB', 'ZiB', 'YiB'),
    'gnu': "KMGTPEZY",
}

def naturalsize(value, binary=False, gnu=False):
    """ Format a number of byteslike a human readable filesize (eg. 10 kB).

    By default, decimal suffixes (kB, MB) are used.  Passing binary=true will
    use binary suffixes (KiB, MiB) are used and the base will be 2**10 instead
    of 10**3.  If ``gnu`` is True, the binary argument is ignored and GNU-style
    (ls -sh style) prefixes are used (K, M) with the 2**10 definition.
    Non-gnu modes are compatible with jinja2's ``filesizeformat`` filter.
    """

    if gnu: suffix = suffixes['gnu']
    elif binary: suffix = suffixes['binary']
    else: suffix = suffixes['decimal']

    base = 1024 if (gnu or binary) else 1000
    bytes = float(value)

    if bytes == 1 and not gnu: return '1 Byte'
    elif bytes < base and not gnu: return '%d Bytes' % bytes
    elif bytes < base and gnu: return '%dB' % bytes

    for i, s in enumerate(suffix):
        unit = base ** (i+2)
        if bytes < unit and not gnu:
            return '%.1f %s' % ((base * bytes / unit), s)
        elif bytes < unit and gnu:
            return '%.1f%s' % ((base * bytes / unit), s)
    if gnu:
        return '%.1f%s' % ((base * bytes / unit), s)
    return '%.1f %s' % ((base * bytes / unit), s)


def network():
    last_update = {'date': time.time(),
                   'in': 0,
                   'out': 0}

    def _network():
        current = psutil.network_io_counters()
        now = time.time()
        dt = now - last_update['date']
        bw_in = (current.bytes_recv - last_update['in']) / dt
        bw_out = (current.bytes_sent - last_update['out']) / dt
        last_update['date'] = now
        last_update['in'] = current.bytes_recv
        last_update['out'] = current.bytes_sent
        return (Block('[ Net:', color='#C4C4C4'),
                Block('↓ %s/s' % naturalsize(bw_in, binary=True), color='#98ADDD', min_width=150, align='middle'),
                Block('↑ %s/s' % naturalsize(bw_out, binary=True), color='#DDDA98', min_width=150, align='middle'),
                Block(']    ', color='#C4C4C4'))

    return _network

def cpu():

    def _cpu():
        cpu_percent = psutil.cpu_percent()
        return (Block('[ Cpu:', color='#C4C4C4'),
                Block(('%d%%' % cpu_percent), color='#9BEF9D', min_width=40, align='center'),
                Block(']', color='#C4C4C4'))

    return _cpu


def mem():

    def _mem():
        phymem = psutil.phymem_usage()
        return (Block('[ Mem:', color='#C4C4C4'),
                Block(('%s (%d%%)' % (naturalsize(phymem.used, binary=True),
                                      phymem.percent)), color='#94529C', min_width=100, align='center'),
                Block(']', color='#C4C4C4'))

    return _mem

if __name__ == '__main__':
    blocks = (cpu(),
              mem(),
              network(),
              clock(),
              lambda: Block('  '))
    i3bar_json(render_lines(blocks))
