use inc::Module::Install;

name           'Git-Scripts-Misc';
all_from       'lib/Git/Scripts/Misc.pm';
author         'Robert Boone <robo4288@gmail.com>';
license        'perl';

requires       'Moose'          => '0';
requires       'IPC::Cmd'       => '0';
requires       'MooseX::Getopt' => '0';
test_requires  'Test::More'     => '0';

requires_external_bin 'git';

install_script 'scripts/git-branch-date';
install_script 'scripts/git-rebase-branches';

auto_install;
WriteAll;
