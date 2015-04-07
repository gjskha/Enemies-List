package Enemies::Alloc;
  
use strict;
use warnings 'all';
use base 'Enemies::Model::Local';

=head1 NAME

Enemies::Alloc - The model for Alloc objects

=head1 DESCRIPTION

Has a many-to-one relationship with Enemies::ASN objects.
Inherits from Enemies::Model::Local .

=head1 AUTHOR

gjskha AT gmail.com

=cut

__PACKAGE__->set_up_table('alloc');
  
# Allocs have an ASN, referenced by the field 'asn'
__PACKAGE__->belongs_to(
    the_asn => 'Enemies::ASN' => 'asn_id'
);
  
1;
