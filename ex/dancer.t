use Mojo::Base -strict; use Test::More;
use Test::Mojo::WithRoles 'PSGI', 'Phantom';

my $t = Test::Mojo::WithRoles->new('ex/dancer.pl');
$t->get_ok('/')->status_is(200)
  ->text_is('body p#name' => 'Leela');

$t->phantom_ok('/' => <<'JS');
  var text = page.evaluate(function(){
    return document.getElementById('name').innerHTML;
  });
  perl.is(text, 'Bender', 'name changed after loading');
JS

done_testing;
