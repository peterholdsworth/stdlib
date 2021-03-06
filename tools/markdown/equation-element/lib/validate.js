'use strict';

// MODULES //

var hasOwnProp = require( '@stdlib/assert/has-own-property' );
var isObject = require( '@stdlib/assert/is-plain-object' );
var isString = require( '@stdlib/assert/is-string' ).isPrimitive;
var isURI = require( '@stdlib/assert/is-uri' );


// MAIN //

/**
* Validates function options.
*
* @private
* @param {Object} opts - destination object
* @param {Options} options - options to validate
* @param {string} [options.className] - element class name
* @param {string} [options.align] - element alignment
* @param {string} [options.raw] - raw equation text
* @param {string} [options.label] - equation label
* @param {string} [options.src] - image source URL
* @param {string} [options.alt] - alternative image text
* @returns {(Error|null)} error object or null
*
* @example
* var opts = {};
* var options = {
*     'className': 'equation',
*     'align': 'center',
*     'raw': '\\operatorname{erf}(x) = \\frac{2}{\\sqrt\\pi}\\int_0^x e^{-t^2}\\,\\mathrm dt'
*     'label': 'eqn:erf',
*     'src': 'https://cdn.rawgit.com/stdlib-js/stdlib/master/lib/node_modules/@stdlib/math/base/special/erf/docs/img/eqn.svg'
*     'alt': 'Error function.'
* };
* var err = validate( opts, options );
* if ( err ) {
*     throw err;
* }
*/
function validate( opts, options ) {
	if ( !isObject( options ) ) {
		return new TypeError( 'invalid input argument. Options argument must be an object. Value: `' + options + '`.' );
	}
	if ( hasOwnProp( options, 'className' ) ) {
		opts.className = options.className;
		if ( !isString( opts.className ) ) {
			return new TypeError( 'invalid option. `className` option must be a string primitive. Option: `' + opts.className + '`.' );
		}
	}
	if ( hasOwnProp( options, 'align' ) ) {
		opts.align = options.align;
		if ( !isString( opts.align ) ) {
			return new TypeError( 'invalid option. `align` option must be a string primitive. Option: `' + opts.align + '`.' );
		}
	}
	if ( hasOwnProp( options, 'raw' ) ) {
		opts.raw = options.raw;
		if ( !isString( opts.raw ) ) {
			return new TypeError( 'invalid option. `raw` option must be a string primitive. Option: `' + opts.raw + '`.' );
		}
	}
	if ( hasOwnProp( options, 'label' ) ) {
		opts.label = options.label;
		if ( !isString( opts.label ) ) {
			return new TypeError( 'invalid option. `label` option must be a string primitive. Option: `' + opts.label + '`.' );
		}
	}
	if ( hasOwnProp( options, 'src' ) ) {
		opts.src = options.src;
		if ( !isURI( opts.src ) ) {
			return new TypeError( 'invalid option. `src` option must be a valid URI. Option: `' + opts.src + '`.' );
		}
	}
	if ( hasOwnProp( options, 'alt' ) ) {
		opts.alt = options.alt;
		if ( !isString( opts.alt ) ) {
			return new TypeError( 'invalid option. `alt` option must be a string primitive. Option: `' + opts.alt + '`.' );
		}
	}
	return null;
} // end FUNCTION validate()


// EXPORTS //

module.exports = validate;
