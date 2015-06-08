use Mojolicious::Lite;
any '/' => 'click';
app->start;
__DATA__

@@ click.html.ep
<script>
  var current = 0, states = ['Leela', 'Bender', 'Fry'];
  function cycle() {
    current = (current + 1) % states.length;
    return states[current];
  }
</script>
Marked For Annihilation:
<input type="button" id="marked"
       value="Leela" onclick="this.value = cycle()">

