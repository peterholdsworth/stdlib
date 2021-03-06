'use strict';

/*
* Regular expression to match a relative require/import literal.
*
* #### Examples
*
* * `'..'`
* * `'../'`
* * `'.'`
* * `'./'`
* * `'/'`
* * `'C:\'`
* * `'c:/'`
*
* Regular expression: `/^(?:\.\.?(?:[\\\/]|$)|\/|(?:[A-Za-z]:)?[\\\/])/`
*
* * `^`
*   - match anything which begins with
* * `(?:`
*   - begin capture but do not remember (1)
* * `\.\.?`
*   - match a `.` literal possibly followed by another `.` literal
* * `(?:[\\\/]|$)`
*   - capture but do not remember a `\\` or `/` literal OR end of string (2)
* * `|`
*   - OR
* * `\/`
*   - match a `/` literal
* * `|`
*   - OR
* * `(?:`
*   - begin capture but do not remember (3)
* * `[A-Za-z]:`
*   - a drive letter followed by a `:` literal
* * `)`
*   - end of capture (3)
* * `?`
*   - match 0 or 1 time
* * `[\\/\]`
*   - match a `\\` or `/` literal
* * `)`
*   - end of capture (1)
*
*
* @private
* @constant
* @type {RegeExp}
* @default /^(?:\.\.?(?:[\\\/]|$)|\/|(?:[A-Za-z]:)?[\\\/])/
*/
var RE_RELATIVE = /^(?:\.\.?(?:[\\\/]|$)|\/|(?:[A-Za-z]:)?[\\\/])/;


// EXPORTS //

module.exports = RE_RELATIVE;
