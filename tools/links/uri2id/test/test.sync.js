'use strict';

// MODULES //

var tape = require( 'tape' );
var uri2id = require( './../lib/sync.js' );


// TESTS //

tape( 'main export is a function', function test( t ) {
	t.ok( true, __filename );
	t.equal( typeof uri2id, 'function', 'main export is a function' );
	t.end();
});

tape( 'the function throws an error if the first argument is not a URI', function test( t ) {
	var values;
	var i;
	values = [
		5,
		'abc',
		NaN,
		null,
		void 0,
		true,
		{},
		[],
		function noop() {}
	];

	for ( i = 0; i < values.length; i++ ) {
		t.throws( badValue( values[i] ), TypeError, 'throws a type error when provided '+values[i] );
	}
	t.end();

	function badValue( value ) {
		return function badValue() {
			uri2id( value );
		};
	}
});

tape( 'if the function encounters an error when attempting to read a database, the function returns the error', function test( t ) {
	var out = uri2id( 'https://www.sublimetext.com/', {
		'database': './nonexisting.json'
	});
	t.strictEqual( out instanceof Error, true, 'returns an error' );
	t.end();
});

tape( 'the function returns the id corresponding to a given URI', function test( t ) {
	var out = uri2id( 'https://www.sublimetext.com/' );
	t.strictEqual( out, 'sublime-text', 'returns correct id' );
	t.end();
});

tape( 'the function returns `null` if the URI is not found in the database', function test( t ) {
	var out = uri2id( 'https://www.not-there.com' );
	t.strictEqual( out, null, 'returns null' );
	t.end();
});

tape( 'the function returns the id corresponding to a given URI (custom database)', function test( t ) {
	var out = uri2id( 'https://www.sublimetext.com/', {
		'database': './test/fixtures/database.json'
	});
	t.strictEqual( out, 'sublime-text', 'returns correct id' );
	t.end();
});
