#!perl
# vim:ts=4:sw=4:expandtab
#
# Please read the following documents before working on tests:
# • http://build.i3wm.org/docs/testsuite.html
#   (or docs/testsuite)
#
# • http://build.i3wm.org/docs/lib-i3test.html
#   (alternatively: perldoc ./testcases/lib/i3test.pm)
#
# • http://build.i3wm.org/docs/ipc.html
#   (or docs/ipc)
#
# • http://onyxneon.com/books/modern_perl/modern_perl_a4.pdf
#   (unless you are already familiar with Perl)
#
# TODO: Description of this file.
# Ticket: #999
# Bug still in: 4.7.2-107-g9b03be6
use i3test i3_autostart => 0;

my $config = <<'EOT';
for_window [instance=".*"] resize grow width 160 px or 16 ppt
bar {
}
EOT

my $pid = launch_with_config($config);

my $i3 = i3(get_socket_path());
$i3->connect()->recv;

open_window;
open_floating_window;
open_window;
open_floating_window;

does_i3_live;

done_testing;
