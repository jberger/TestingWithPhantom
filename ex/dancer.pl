use Dancer;
use Path::Tiny;
my $html = path('ex/templates/dynamic.html.ep')->slurp;
get '/' => sub { return $html };
dance;

