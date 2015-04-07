package Enemies::Snippet;

=head1 NAME

Enemies::Snippet - set and get snippets of text.

=head1 SYNOPSIS

my $snippet = Enemies::Snippet->new;

# get the snippet for "fresh" links (I don't clear my cache very much):

my $random_string = $snippet->random_string;

# set it

$snippet->random_string("new_value");

# get the snippet for last whois run 

my $last_run = $snippet->last_run;

# set it

$snippet->last_run(`date`); # or whatever

# get the snippet for last mod time

my $last_mod = $snippet->last_mod;

# set it

$snippet->last_mod(`date`); # or whatever

# "private" methods

$self->_update($column, $value);

$self->_fetch($column);

=head1 DESCRIPTION

Use this module for creating and reusable snippets of text.

=head1 AUTHOR

gjskha AT gmail.com

=cut

use strict;
use warnings 'all';
use Enemies::Status;

sub new {
    my $class = shift;
    my $self = bless {}, $class; 
    return $self;
}

sub random_string {
    my $self = shift;
    if (@_) {
        my $random = shift;
        $self->_update(random_string => $random);
    } else {
        return $self->_fetch("random_string");     
    }
}

sub last_mod {
    my $self = shift;
    if (@_) {
        my $last_mod = shift;
        $self->_update(last_mod => $last_mod);
    } else {
        return $self->_fetch("last_mod");     
    }
}

sub last_run {
    my $self = shift;
    if (@_) {
        my $last_run = shift;
        $self->_update(last_run => $last_run);
    } else {
        return $self->_fetch("last_run");     
    }
}

sub _update {
    my $self = shift;
    my ($k, $v) = @_;

    eval {
        my $dbh = Enemies::Status->db_Main || die $@;
        my $sth = $dbh->prepare(qq{update status set $k = '$v'}) || die $dbh->errstr;
        $sth->execute() || die "could not: " . $dbh->errstr;
    };
 
    if ($@) {
        print STDERR "error updating: $@\n";
    }

}

sub _fetch {
    my $self = shift;
    my $col = shift;

    my $dbh = Enemies::Status->db_Main || die $@;
    my $sth = $dbh->prepare(qq{select $col from status}) || die $dbh->errstr;
    $sth->execute() || die $dbh->errstr;
    my $result = $sth->fetchrow_hashref || die $dbh->errstr;
    return $result->{$col};
}

1;
