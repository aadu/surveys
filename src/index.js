// pull in desired CSS/SASS files
require( './styles/main.scss' );

// inject bundled Elm app into div#main
var Elm = require( './Main' );
var app = Elm.Main.embed( document.getElementById( 'main' ) );
app.ports.dialog.subscribe(function(id) {
    $('#' + id).openModal();
});

app.ports.autoresize.subscribe(function(id) {
    console.log(id);
    $('#' + id).val('autoresize');
    setTimeout(function(){
      $('#' + id).trigger('autoresize');
    }, 20);
});
