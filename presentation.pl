use Mojolicious::Lite;

plugin 'RevealJS';

any '/' => 'presentation';

app->start;

__DATA__

@@ presentation.html.ep

% layout 'revealjs';

<style>
  .no-uc { text-transform: none !important; }
  .reveal pre code {
    max-height: 450px;
    padding: 20px;
  }

  #js {
    font-family: cursive;
    color: red;
    text-transform: none;
  }

  #placeholder:not(.visible) {
    display: none;
  }
</style>


<section>
  <h2>Test Your App's JavaScript using <span class="no-uc">Test::Mojo::Role::Phantom</span><h2>
  <h3>Joel Berger - YAPC::NA 2015</h3>
  <img width="40%" src="group.png">
</section>

<section>

  <h2>About this talk</h2>

  <ul>
    <li>I first gave this talk at YAPC::NA on June 8, 2015</li>
    <li>I updated it on July 23, 2015 for Chicago.pm</li>
    <li>The talk is hosted at <a href="http://jberger.github.io/TestingWithPhantom" target="_blank">http://jberger.github.io/TestingWithPhantom</a></li>
    <li>The source is available at <a href="https://github.com/jberger/TestingWithPhantom" target="_blank">https://github.com/jberger/TestingWithPhantom</a></li>
    <li>All code samples and all tests:
      <ul>
        <li>are complete and run as shown</li>
        <li>are included in the repository</li>
      </ul>
    </li>
    <li>This presentation is a Mojolicious app!
      <ul><li>Using <a href="http://metacpan.org/pod/Mojolicious::Plugin::RevealJS">Mojolicious::Plugin::RevealJS</a></li><ul>
    </li>
  </ul>

</section>

<section>
  <h2>Perl's Testing Culture</h2>

  <ul>
    <li>Most (useful) modules on CPAN are very well tested</li>
    <li>Numerous testing modules on CPAN as well</li>
    <li>CPAN Testers network (more recently Travis too)</li>
  </ul>

  <div style="min-height: 50px"></div>

  <h2 class="fragment grow">This is Awesome!</h2>
</section>

<section>
  <section>
    <h2>How Do We Encourage People To Write Good Test Suites?</h2>
  </section>

  <section>
    <h2>Make Testing Easy<h2>
    <img src="bender_relaxing.gif">
  </section>

  <section>
    <h4>Testing A Template</h4>
    %= include_code 'ex/templates/simple.html.ep', language => 'html'
  </section>
  <section>
    <h4 class="no-uc">Test::Mojo</h4>
    %= include_code 'ex/simple.t'
  </section>

  <section>
    <h2>Pretty Easy Right?!</h2>
  </section>
</section>

<section>
  <section>
    <h2>Perl Authors Write</h2>
    <h2>Good Perl Tests</h2>
  </section>
  <section>
    <h2>But JavaScript Tests?</h2>
    <img class="fragment" src="bad_tests.png">
  </section>
</section>

<section>
  <section>
    <img src="planet.png">
  </section>

  <section>
    <h2>How Do We Encourage People To Write JavaScript Tests?</h2>
  </section>

  <section>
    <h2>
      Make
      <span id="placeholder" class="fragment">
        <span id="js" class="fragment">JavaScript</span>
      </span>
      Testing Easy
    <h2>
  </section>
</section>

<section>
  <h2>Design Goals</h2>
  <ul>
    <li class="fragment">#1: Do not depend on any external running servers</li>
    <li class="fragment">#2: Emit TAP in the normal way Perl tests do</li>
    <li class="fragment">#3: Not have to reimplement lots of Test::More functionality</li>
  </ul>
</section>

<section>
  <section>
    <h4>#1: Do not depend on any external running servers</h4>
    <h3>Native Perl</h3>
    <ul>
      <li>Test::Mojo starts a in-process application server</li>
      <li>Perl can't (natively) interpret JavaScript</li>
      <li>Even if it could, it would need a DOM</li>
    <ul>
  </section>
  <section>
    <h4>#1: Do not depend on any external running servers</h4>
    <h3>Selenium</h3>
    <p>Selenium requires external running servers</p>
    <ul style="float: left; margin: 15px;">
      <li>Application server</li>
      <li>Selenium (remote control) server</li>
      <li>Browser?</li>
    </ul>
    <image style="width: 40%" src="selenium.png">
  </section>
  <section>
    <h4>#1: Do not depend on any external running servers</h4>
    <h3>Phantom JS</h3>
    <ul>
      <li>Headless WebKit browser</li>
      <li><a href="http://phantomjs.org">http://phantomjs.org</a></li>
      <li>Easy to install</li>
      <li>Free / Open source</li>
      <li class="fragment">We could spin up a phantomjs process on demand?</li>
    </ul>
    <br>
    <img class="fragment" width="40%" src="money.jpg">
  </section>
</section>

<section>
  <section>
    <h3>#2: Emit TAP in the normal way Perl tests do</h3>
    <ul>
      <li>Important for integrating into existing architecture</li>
      <li>Could use Tape.js from JavaScript side</li>
      <li>Could use existing Perl Test::More somehow</li>
    </ul>
  </section>
  <section>
    <h4>#2: Emit TAP in the normal way Perl tests do</h4>
    <h3>Practical Considerations</h3>
    <ul>
      <li>JavaScript-side solutions are hard to install</li>
      <li>Merge JS-emitted TAP into surrounding TAP, correctly?</li>
    </ul>
  </section>
</section>

<section>
    <h3>#3: Not have to reimplement lots of Test::More functionality</h3>

    <ul>
      <li>This is purely for my benefit</li>
      <li>With #2, leads to a simple solution
        <ul>
          <li>Use Test::More direct</li>
          <li>Call Perl functions "from JavaScript"</li>
        </ul>
      </li>
    </ul>
</section>

<section>
  <h2 class="no-uc">Test::Mojo::Role::Phantom</h2>
  <ul>
    <li>A test method call
      <ul>
        <li>start a subtest in Perl</li>
        <li>start phantomjs</li>
        <li>set up the javascript environment</li>
      </ul>
    </li>
    <li class="fragment">Send JSON over pipe to the Perl process
      <ul>
        <li>["Test::More::ok", 1, "basic check"]</li>
        <li>Execute inside Perl/subtest</li>
      </ul>
    </li>
    <li class="fragment">Future work: A side-channel websocket also be nice</li>
  </ul>
</section>

<section>
  <section>
    <h2>Testing Dynamics</h2>
    <img width="40%" src="dynamic.gif">
  </section>
  <section>
    <h4>Testing A Template</h4>
    %= include_code 'ex/templates/dynamic.html.ep', language => 'html'
  </section>
  <section>
    <h4 class="no-uc">Test::Mojo::Role::Phantom</h4>
    %= include_code 'ex/dynamic.t'
  </section>
</section>

<section>
  <section>
    <h4>A More Interesting Example</h4>
    <img src="mom.jpg">
    <h4><span class="no-uc">MomCorp</span> Annihilation Machine</h4>
  </section>
  <section>
    %= include_code 'ex/click.pl'
  </section>
  <section>
    %= include_code 'ex/click.t'
  </section>
</section>

<section>
  <section>
    <h2>... But I Don't Use Mojolicious</h2>
    <img src="zoidberg_sad.jpg">
  </section>
  <section>
    <h3>Dancer Your Thing?</h3>
    %= include_code 'ex/dancer.pl'
  </section>
  <section>
    <h4><span class="no-uc">Test::Mojo::Role::PSGI</span> Makes This Easy Too</h4>
    %= include_code 'ex/dancer.t'
  </section>
</section>

<section>
  <img src="winning.jpg">
  <ul>
    <li><a href="https://metacpan.org/pod/Test::Mojo::Role::Phantom">Test::Mojo::Role::Phantom</a></li>
    <li><a href="http://phantomjs.org/">http://phantomjs.org</a></li>
    <li><a href="http://mojolicio.us">http://mojolicio.us</a></li>
    <li>#mojo on irc.perl.org</li>
  </ul>
</section>
