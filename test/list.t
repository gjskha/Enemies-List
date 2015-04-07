use Test::Simple tests => 5;

use strict;
use warnings;
use File::Basename;
use lib dirname(__FILE__) . "/../lib";
use Enemies::List;
use Data::Dumper;

my $list = Enemies::List->new;

ok( ref $list eq "Enemies::List", "creating a new object works" );

my @list = $list->fetch;
ok( scalar @list > 0, "fetch() method works" );

print Dumper @list;

my @asn = $list->asn;
ok( scalar @asn > 0, "asn() method works" );

my @name = $list->name;
ok( scalar @name > 0, "name() method works" );

my @ct = $list->creation_time;
ok( scalar @ct > 0, "creation_time() method works" );

for (@{Enemies::List->new->fetch}) {
    print $_->asn;
}
