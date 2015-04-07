use Test::Simple tests => 4;

use File::Basename;
use lib dirname(__FILE__) . "/../lib";
use Enemies::DB::Note;

# create an object
my $note = Enemies::DB::Note->create( entity => "testing_note", note => "did it work?" );
ok( $note->entity eq "testing_note", "create() works" );

# count object
my $count = Enemies::DB::Note->count_search( entity => "testing_note" );
ok( $count > 0, "count_search() works" );

# search for object
my @search_results = Enemies::DB::Note->search( entity => "testing_note" );
my $first_res = shift @search_results;
ok($first_res->entity eq "testing_note", "search() works" );

#my $search_results = Enemies::DB::Note->search( entity => "testing_note" );
defined $search_results[0]->note ? print "exists" : print "don't exist";

for(Enemies::DB::Note->search( entity => "testing_note" )) {
     print $_->entity, "\n";
}
# delete the object
ok( ref $note->delete eq "Class::DBI::Lite::Object::Has::Been::Deleted", "delete() works" );
