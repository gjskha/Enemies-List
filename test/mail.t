use Test::Simple tests => 4;
use File::Basename;
use lib dirname(__FILE__) . "/../lib";
use Enemies::Mail;

my $mail = Enemies::Mail->new();

ok( defined($mail) && ref $mail eq 'Enemies::Mail', 'new() works' );

$mail->to('test@test.test');
ok( $mail->to eq 'test@test.test', "Recipient had  expected value" );

$mail->from('test@test.test');
ok( $mail->from eq 'test@test.test', "Sender had expected value" );

$mail->subject('Testing');
ok( $mail->subject eq "Testing", "Subject line had expected value" );
