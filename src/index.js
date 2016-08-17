// pull in desired CSS/SASS files
require( './styles/main.scss' );

// inject bundled Elm app into div#main
var Elm = require( './Main' );
var app = Elm.Main.embed( document.getElementById( 'main' ) );
app.ports.showDialog.subscribe(function(id) {
    console.log('!!!');
    $('#' + id).openModal();
});
