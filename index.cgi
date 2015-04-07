#!/usr/bin/perl -w

=head1 NAME

index.cgi - web front end to the Enemies List.

=head1 AUTHOR

gjskha AT gmail.com

=cut

use strict;
use lib 'lib';
use Enemies::Web;

my $app = Enemies::Web->new();

$app->run();
