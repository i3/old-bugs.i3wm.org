// vim:ts=8:expandtab
#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <sys/time.h>
#include <sys/ioctl.h>


#include "i3status.h"


#define BUFFER_SIZE 1024
char buffer[BUFFER_SIZE+1];


void update_buffer(bool bol, size_t max) {
        size_t s;
        int i;

        s = fread(buffer, 1, BUFFER_SIZE, stdin);
        buffer[s] = 0;
        i = s-1;

        if(bol) {
                if(buffer[i] == '\n') {
                        buffer[i] = 0;
                        s--;
                        i--;
                }

                while(i >= 0) {
                        if(buffer[i] == '\n')
                                break;
                        i--;
                }

                if(i)
                    memmove(buffer, &buffer[i], s-i);
        }
        else {
                while(i >= 0) {
                        if(buffer[i] == '\n')
                                buffer[i] = ' ';
                        i--;
                }
        }

        if(s > max)
            buffer[max] = 0;
}

/*
 * Get input and print it
 */
void print_pipe(bool break_on_line, int max_size) {
        fd_set rs;
        struct timeval tv;

        tv.tv_sec = 0;
        tv.tv_usec = 100;

        FD_ZERO(&rs);
        FD_SET(fileno(stdin), &rs);

        select(fileno(stdin), &rs, NULL, NULL, &tv);
        if(FD_ISSET(fileno(stdin), &rs))
                update_buffer(break_on_line, max_size);

        printf("%s", buffer);
}

