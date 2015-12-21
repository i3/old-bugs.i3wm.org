#!perl
# vim:ts=4:sw=4:expandtab
#
# Tests whether moving containers works across different outputs.
#
use List::Util qw(first);
use i3test i3_autostart => 0;

my $config = <<EOT;
# i3 config file (v4)
font -misc-fixed-medium-r-normal--13-120-75-75-C-70-iso10646-1

fake-outputs 1024x768+0+0,1024x768+1024+0
EOT
my $pid = launch_with_config($config);

################################################################################
# Setup workspaces so that they stay open (with an empty container).
################################################################################

is(focused_ws, '1', 'starting on workspace 1');
# ensure workspace 1 stays open
open_window;

cmd 'focus output right';
is(focused_ws, '2', 'workspace 2 on second output');
# ensure workspace 2 stays open
open_window;

################################################################################
# Move window over to the first workspace. Verify that it ends up right next to
# the existing window.
################################################################################

cmd 'move left';
is(scalar @{get_ws_content('2')}, 0, 'no more windows on workspace 2');
is(scalar @{get_ws_content('1')}, 2, 'two windows on workspace 1');

################################################################################
# Now move that window back to the right output, but create a stacked container
# there first.
################################################################################

cmd 'workspace 2';
open_window;
cmd 'layout stacked';

my $old_content = get_ws_content('2');
diag(Dumper($old_content));

cmd 'focus left';
cmd 'move right';

my $new_content = get_ws_content('2');
diag(Dumper($new_content));

is(scalar @{get_ws_content('1')}, 1, 'only one window on workspace 1');

exit_gracefully($pid);

done_testing;
