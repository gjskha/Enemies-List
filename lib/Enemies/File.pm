package Enemies::File;

use strict;
use JSON;

sub new {
    my $class = shift;
    my $self = bless {}, $class; 
    return $self;
}

sub slurp_json {

    my ($self, $file) = @_;

    if ( -f $file ) {
        open(F, "<$file") || die "can't open file $file: $!";
        my $json = do { local $/; <F> };
        close(F);
        my $slurp = decode_json($json);
        $self->{slurp} = $slurp;
        return $slurp;
    } else {
        die "can't access file $file: $!";
    }
}

sub dump_struct {

    my $self = shift;
    my $opts = shift;
   
    my %opts = %{$opts};

    if ( -f $opts{file} ) {
        my $json = encode_json($opts{struct});
        open(F, ">$opts{file}") || die "can't open file $opts{file}: $!";
        print F $json;
        close(F);
    } else {
        die "can't access file $opts{file}: $!";
    }

    return $self;
}

1;
