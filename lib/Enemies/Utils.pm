package Enemies::Utils;

use strict;
use Enemies::File;

sub new {
    my $class = shift;
    my $self = bless {}, $class; 
    $self->{filer} = Enemies::File->new;
    return $self;
}

sub sidebar {

    my $self = shift;
    my $enemies_file = shift;
    my $as_data = $self->{filer}->slurp_json($enemies_file);
    my $sidebar;

    foreach my $as (@{$as_data->{enemies}}) {
        push (@{$sidebar}, { 
            "name" => $as->{name},
             "asn" => $as->{asn}, 
          "random" => $as_data->{random}, 
        });
    }

    return $sidebar;
}

sub lastrun {
    my $self = shift;
    my $file = shift;
    my $data = $self->{filer}->slurp_json($file);
    return $data->{last_mod};
}

1;
