use Test::Simple tests => 4;

use File::Basename;
use lib dirname(__FILE__) . "/../lib";
use Enemies::Alloc;
use DateTime;

# create an object
my $alloc = Enemies::Alloc->create( alloc => "12.34.56.78", asn_id => 1234, prom => "y" );
ok( $alloc->alloc eq "12.34.56.78", "create() works" );

# count object
my $count = Enemies::Alloc->count_search( alloc => "12.34.56.78" );
ok( $count > 0, "count_search() works" );

# search for object
my @search_results = Enemies::Alloc->search( alloc => "12.34.56.78" );
my $first_res = shift @search_results;
ok($first_res->alloc eq "12.34.56.78", "search() works" );

# delete the object
ok( ref $alloc->delete eq "Class::Lite::Object::Has::Been::Deleted", "delete() works" );
