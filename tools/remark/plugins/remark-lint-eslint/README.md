# ESLint

> [remark][remark] plugin to lint Markdown JavaScript code blocks using [ESLint][eslint].


<section class="usage">

## Usage

``` javascript
var plugin = require( '/path/to/@stdlib/tools/remark/plugins/remark-lint-eslint' );
```

#### plugin()

A [remark][remark] plugin, which when provided a Markdown abstract syntax `tree`, lints JavaScript code blocks using the default [ESLint][eslint] configuration.

``` javascript
var remark = require( 'remark' );

// Create a synchronous Markdown text linter:
var linter = remark().use( plugin ).procecssSync;

// Lint Markdown:
var vfile = linter( '``` javascript\nvar beep = \'boop\';\n```' );
```

#### plugin.factory( \[options\] )

Returns a configured [remark][remark] plugin for linting JavaScript code blocks. 

``` javascript
var remark = require( 'remark' );

// Create a synchronous Markdown text linter:
var linter = remark().use( plugin.factory() ).procecssSync;

// Lint Markdown:
var vfile = linter( '``` javascript\nvar beep = \'boop\';\n```' );
```

The function recognizes the following `options`:

* __config__: path to an [ESLint][eslint] configuration file. A configuration path is resolved relative to the current working directory of the calling process.

To specify configuration `options`, set the respective properties.

``` javascript
var remark = require( 'remark' );

// Define options:
var opts = {
    'config': '/path/to/.eslintrc'
};

// Create a plugin:
var lint = plugin.factory( opts );

// Create a synchronous Markdown text linter:
var linter = remark().use( lint ).procecssSync;

// Lint Markdown:
var vfile = linter( '``` javascript\nvar beep = \'boop\';\n```' );
```

</section>

<!-- /.usage -->


<section class="notes">

## Notes

<!--lint disable code-block-style -->

* The plugin supports __configuration comments__, which are HTML comments containing [ESLint][eslint] configuration settings located immediately above a fenced code block.

      ## Heading

      Beep boop.

      <!-- eslint-disable no-new-wrappers, no-sparse-arrays -->

      ``` javascript
      var x = new Number( 3.14 );

      var arr = [ 1, , , 4, 5 ];
      ```

  The plugin supports multiple consecutive comments.

      ## Heading

      Beep boop.

      <!-- eslint-disable no-new-wrappers -->

      <!-- eslint-disable no-sparse-arrays -->

      ``` javascript
      var x = new Number( 3.14 );

      var arr = [ 1, , , 4, 5 ];
      ```

  Prior to linting, the plugin converts the content of each HTML comment to a JavaScript comment and prepends each comment to the content inside the code block. Accordingly, the plugin would transform the above example to

  <!-- eslint-disable no-new-wrappers, no-sparse-arrays -->

  ``` javascript
  /* eslint-disable no-new-wrappers */
  /* eslint-disable no-sparse-arrays */
  var x = new Number( 3.14 );

  var arr = [ 1, , , 4, 5 ];
  ```

* Configuration comments __only__ apply to a code block which follows immediately after. Hence, the plugin does __not__ apply the following configuration comment to a subsequent code block.

      ## Heading

      <!-- eslint-disable no-new-wrappers -->

      Beep boop.

      ``` javascript
      var x = new Number( 3.14 );
      ```

* The plugin lints each code block separately, and configuration comments are __not__ shared between code blocks. Thus, one must repeat configuration comments for each code block.

      ## Heading

      Beep.

      <!-- eslint-disable no-new-wrappers -->

      ``` javascript
      var x = new Number( 3.14 );
      ```

      Boop.

      <!-- eslint-disable no-new-wrappers -->

      ``` javascript
      var x = new Number( -3.14 );
      ```

* To skip linting for a particular code block, use the __non-standard__ comment `<!-- eslint-skip -->`.

      ## Heading

      Beep boop.

      <!-- eslint-skip -->

      ``` javascript
      var x = new Number( 3.14 );
      ```

  For skipped code blocks, the plugin reports neither rule nor syntax errors.


<!--lint enable code-block-style -->

</section>

<!-- /.notes -->


<section class="examples">

## Examples

<!-- eslint-disable no-sync -->

``` javascript
var join = require( 'path' ).join;
var resolve = require( 'path' ).resolve;
var remark = require( 'remark' );
var readFileSync = require( '@stdlib/fs/read-file' ).sync;
var factory = require( '/path/to/@stdlib/tools/remark/plugins/remark-lint-eslint' ).factory;

// Define path to an ESLint config file:
var config = resolve( __dirname, '..', '..', '..', '..', 'etc', 'eslint', '.eslintrc.markdown.js' );

// Load a Markdown file:
var fpath = join( __dirname, 'examples', 'fixtures', 'file.md' );
var file = readFileSync( fpath );

// Define plugin options:
var opts = {
    'config': config
};

// Create a plugin:
var plugin = factory( opts );

// Lint code blocks:
var out = remark().use( plugin ).processSync( file.toString() );

console.log( out );
```

</section>

<!-- /.examples -->


<section class="links">

[remark]: https://github.com/wooorm/remark
[eslint]: http://eslint.org/

</section>

<!-- /.links -->
