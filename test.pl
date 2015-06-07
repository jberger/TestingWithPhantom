use Mojolicious::Lite;

helper input => sub {
  my ($c, $name, $value, $type) = @_;
  $c->render_to_string(
    inline => '<input type="<%== $type %>" value="<%= $value %>" name="<%== $name %>">',
    name => $name,
    value => $value || '',
    type => $type || 'text',
  );
};

any '/' => 'index';

app->start;

__DATA__

@@ index.html.ep

%= input 'my_name', 'my_value'

