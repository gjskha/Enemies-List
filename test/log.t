use Test::Simple tests => 4;

use File::Basename;
use lib dirname(__FILE__) . "/../lib";
use Enemies::Log;
use DateTime;
use Data::Dumper; 

my $now = DateTime->now->strftime("%Y-%m-%d %H:%M:%S");

# create an object
my $log = Enemies::Log->create( who => "testing_logger", what => "did it work?", creation_time => $now);
ok( $log->who eq "testing_logger", "create() a new object works" );

# count method for object
my $count = Enemies::Log->count_search( who => "testing_logger" );
ok( $count > 0, "count_search() method works" );

# search method for object
my @search_results = Enemies::Log->search( who => "testing_logger" );
my $first_res = shift @search_results;
ok($first_res->who eq "testing_logger", "search() method works" );

my @search_results = Enemies::Log->search_where({who => { LIKE => '%'}}, {order_by => "creation_time desc"});

my $pager = Enemies::Log->pager({
  who => { LIKE => '%'}
}, {
  order_by    => 'creation_time desc',
  page_number => 1,
  page_size   => 10,
});

print Dumper $pager;

# Get the first page of items from the pager:
my @items = $pager->items;
#print Dumper @items;

# Is the a 'previous' page?:
if( $pager->has_prev ) {
  print "Prev page number is " . ( $pager->page_number - 1 ) . "\n";
}
 
# Say where we are in the total scheme of things:
print "Page " . $pager->page_number . " of " . $pager->total_pages . "\n";
print "Showing items " . $pager->start_item . " through " . $pager->stop_item . " out of " . $pager->total_items . "\n";
 
# Is there a 'next' page?:
if( $pager->has_next ) {
  print "Next page number is " . ( $pager->page_number + 1 ) . "\n";
}
 
# Get the 'start' and 'stop' page numbers for a navigation strip with
# up to 5 pages before and after the 'current' page:
my ($start, $stop) = $pager->navigations( 5 );
for( $start..$stop ) {
  print "Page $_ | ";
}


# delete the object
ok( ref $log->delete eq "Class::Lite::Object::Has::Been::Deleted", "delete() method works" );
