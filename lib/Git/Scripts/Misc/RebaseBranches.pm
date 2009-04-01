package Cpanel::Git::RebaseBranches;
use Moose;

with 'Git::Scripts::Misc', 'MooseX::Getopt';

has 'base' => (
    is      => 'rw',
    isa     => 'Str',
    default => 'master',
);

has 'branch' => (
    traits      => [ 'Getopt' ],
    is          => 'rw',
    isa         => 'ArrayRef',
    default     => sub { [] },
    cmd_aliases => 'b',
);

sub current_branch {
    my ($self) = @_;
    my @data = split /\n/, $self->branches;
    foreach my $line (@data) {
        if ( $line =~ /^\*\s*(\S+)/ ) {
            return $1;
        }
    }
}

sub run {
    my ($self) = @_;
    my $current = $self->current_branch;
    foreach my $branch (@{$self->branch}) {
        $self->git_command('checkout', $branch);
        $self->git_command('rebase', $self->base);
    }
    $self->git_command('checkout', $current);
    my $num = scalar @{$self->branch};
    my $has  = 'has';
    my $es   = '';
    if ($num > 1) {
        $has = 'have';
        $es  = 'es';
    }
    print 'Branch' . "$es " . _commify_series(@{$self->branch}), " $has " .'been rebased to ' . $current . ".\n";
}

sub _commify_series {
        ( @_ == 0 ) ? ''
      : ( @_ == 1 ) ? $_[0]
      : ( @_ == 2 ) ? join( " and ", @_ )
      :               join( ', ', @_[ 0 .. $#_ - 1 ], "and $_[-1]" );
}


no Moose;
1;
