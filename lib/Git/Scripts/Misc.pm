package Git::Scripts::Misc;
use Moose::Role;
use IPC::Cmd ();
use Carp qw(confess);

our $VERSION   = '0.0.1';
our $AUTHORITY = 'cpan:RLB';

has git_bin => (
    is      => 'ro',
    isa     => 'Str',
    default => sub {
        return ( -e '/usr/bin/git' ) ? '/usr/bin/git' : '/usr/local/bin/git';
    }
);

has branches => (
    is      => 'ro',
    isa     => 'Str',
    lazy    => 1,
    default => sub {
        my ($self) = @_;
        return $self->git_command( 'branch', '-a', '-v' );
    },
);

sub git_command {
    my ( $self, @args ) = @_;

    my $output;
    my $result = IPC::Cmd::run(
        command => [ $self->git_bin, @args ],
        verbose => 0,
        buffer  => \$output,
    );

    if ($result) {
        return $output;
    }
    else {
        confess 'git command failed: git ', join ' ', @args;
    }
}

no Moose::Role;
1;
