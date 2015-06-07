use Mojolicious::Lite;

use Test::More;
use Test::Mojo;

any '/' => 'simple';

my $t = Test::Mojo->new;
$t->get_ok('/')->status_is(200)
  ->text_is('title' => 'Simple')
  ->text_is('body p#name' => 'Leela');

done_testing;

