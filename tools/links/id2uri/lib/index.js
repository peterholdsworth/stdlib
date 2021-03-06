'use strict';

/**
* Return the URI corresponding to a provided id.
*
* @module @stdlib/tools/links/id2uri
*
* @example
* var id2uri = require( '@stdlib/tools/links/id2uri' );
*
* id2uri( 'bibtex', clbk );
*
* function clbk( error, uri ) {
*   if ( error ) {
*       throw error;
*   }
*   console.log( uri );
* 	// => 'http://www.bibtex.org/'
* }
*/

// MODULES //

var setReadOnly = require( '@stdlib/utils/define-read-only-property' );
var id2uri = require( './async.js' );
var sync = require( './sync.js' );


// MAIN //

setReadOnly( id2uri, 'sync', sync );


// EXPORTS //

module.exports = id2uri;
