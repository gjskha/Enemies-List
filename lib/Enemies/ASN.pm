package Enemies::ASN;
  
use strict;
use warnings 'all';
use base 'Enemies::Model::Local';

=head1 NAME

Enemies::ASN - The model for ASN objects

=head1 DESCRIPTION

Has a one-to-many relationship with Enemies::Alloc objects.
Inherits from Enemies::Model::Local .

=head1 AUTHOR

gjskha AT gmail.com

=cut
 
__PACKAGE__->set_up_table('asn');
  
__PACKAGE__->has_many(
    these_allocs => 'Enemies::Alloc' => 'asn_id' 
);
  
1;
