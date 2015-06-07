use Mojo::Base -strict; use Test::More;
use Test::Mojo::WithRoles 'Phantom';
require 'ex/click.pl';

my $t = Test::Mojo::WithRoles->new;
$t->phantom_ok('/' => <<'JS');
  function click_get() {
    return page.evaluate(function() {
      var marked = document.getElementById('marked');
      marked.click(); return marked.value;
    })
  }
  perl.is(click_get(), 'Bender', 'once');
  perl.is(click_get(), 'Fry',    'twice');
  perl.is(click_get(), 'Leela',  'three times a lady');
  perl.is(click_get(), 'Bender', 'kiss my shine metal ...');
JS

done_testing;

