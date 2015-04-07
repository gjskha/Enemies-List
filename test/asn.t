use Test::Simple tests => 6;

use File::Basename;
use lib dirname(__FILE__) . "/../lib";
use Enemies::ASN;
use DateTime;
use Data::Dumper;

my $now = DateTime->now->strftime("%Y-%m-%d %H:%M:%S");

# create an object
my $asn = Enemies::ASN->create( asn => "44224422", name => "test_asn", creation_time => $now, disp => "test" );
ok( $asn->name eq "test_asn", "create() works" );

# count object
my $count = Enemies::ASN->count_search( name => "test_asn" );
ok( $count > 0, "count_search() works" );

# search for object
my @search_results = Enemies::ASN->search( name => "test_asn" );
my $first_res = shift @search_results;
ok($first_res->name eq "test_asn", "search() works" );

my $retrieve = Enemies::ASN->retrieve( 244 );

ok($retrieve->asn_id eq 244, "retrieve works" );

my @allocs = $retrieve->these_allocs;
my $alloc = shift @allocs;

ok( defined($alloc) && ref $alloc eq 'Enemies::Alloc', 'ORM linkage seems to be working' );

# delete the object
ok( ref $asn->delete eq "Class::Lite::Object::Has::Been::Deleted", "delete() works" );
