package Git::Scripts::Misc::BranchDate;
use Moose;

with 'Git::Scripts::Misc';

has branch_name_length => ( is => 'rw', isa => 'Int', default => 0 );
has time_length        => ( is => 'rw', isa => 'Int', default => 0 );

sub parse {
    my ($self) = @_;

    my @stash;
    my $branch_name_length = 0;
    my $time_length        = 0;
    my @data               = split /\n/, $self->branches;

    foreach my $line (@data) {
        my $c = ' ';
        if ( $line =~ /^\*/ ) {
            $c = '*';
            $line =~ s/^\*//;
        }
        $line =~ s/^\s+//;
        my ( $branch, $sha, $log ) = split /\s+/, $line, 3;
        my $time = $self->git_command( 'log', '-n', '1', '-a', '--pretty=format:%Cred%ar%Creset', $sha );
        push @stash, { current => $c, branch_name => $branch, time => $time, log => $log };
        $branch_name_length = ( $branch_name_length > length($branch) ) ? $branch_name_length : length($branch);
        $time_length        = ( $time_length > length($time) )          ? $time_length        : length($time);
    }
    $self->branch_name_length( $branch_name_length + 1 );
    $self->time_length($time_length);
    return \@stash;
}

sub run {
    my ($self) = @_;
    my $stash = $self->parse;
    foreach my $hash (@$stash) {
        my $log = $hash->{'log'};
        if (length($log) > 64) {
            $log = substr($hash->{'log'}, 0, 64);
            $log =~ s/\s+$//;
            $log .= '...';
        }
        printf "%s %-*s%-*s %s\n", $hash->{'current'}, $self->branch_name_length, $hash->{'branch_name'}, $self->time_length, $hash->{'time'}, $log;
    }
}

no Moose;
1;
