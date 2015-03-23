/* ============================================================ */
/* Language Basics                                              */
/* ============================================================ */

// Everything is an Object
// -----------------------
{begin nostudent}
// one superclass at a time
10.class.superclass.superclass.superclass.superclass
{end nostudent}



// Basic Types
// -----------

// numbers
10.class;       // Integer
10.0.class;     // Float

// text
"string".class; // String
$s.class;       // Char
'symbol'.class; // Symbol
\symbol.class;  // Symbol


\symbol == 'symbol';   // equal
"string" == "string";  // equal
"string" === "string"; // identical

// boolean
true;
false;



// Arithmetic Operators
// --------------------

2 + 4;   // add
2 - 4;   // subtract
2 / 4;   // div
2 * 4;   // multiply
2 ** 4;  // power
2 % 4;   // modulo

// functional style
pow(2, 4);
mod(2, 4);
2.min(4);
min(2, 4);


// Useful maths Operators
// -----------------------

-4.abs;      // absolute
4.neg;       // negative
4.5.round;   // round
4.5.floor;   // round down
4.5.ceil;    // round up
-4.sign;     // sign (-1, 0 or 1)
4.sqrt;      // square root
69.midicps;  // MIDI -> cycles per second
440.cpsmidi; // cycles per second -> MIDI
7.midiratio; // MIDI -> ratio
-0.3.dbamp;  // decibels to amplitude
0.5.ampdb;   // amplitude to decibels
pi.cos;
pi.sin;
pi.tan;


// Logical Operators
// -----------------

2 < 4;              // less than
2 > 4;              // greater than
2 <= 4;             // less than or equal
2 >= 4;             // greater than or equal
2 == 4;             // equal
2 != 4;             // not equal
[2, 4] === [2, 4];  // identical (same object?)
2 !== 4;            // not identical

true && false;      // logical and
true || false;      // logical or
(2 == 4).not;       // negate



// String Operators
"one" + "two";
"one" ++ "two";
"one" +/+ "two";



// Operator precedence
// -------------------
// None! Left to right

2 + 10 * 5;     // (2 + 10) * 5
2 + (10 * 5);

// ouch
if(true || 4 < 10) {
{begin nostudent}
if(true || (4 < 10)) {
{end nostudent}
    'yo'.postln;
};



// Control Structures
// ------------------

// if
if(10 > 5) {
    "true".postln;
};

// if / else
if(5 > 10) {
    "true?".postln;
} {
    "false".postln;
};

// if / else if

if(5 > 10) {
    "true?".postln;
} {
    if(4 < 20) {
        "a bit annoying".postln;
    };
};

// switch
(
var hit = [\kick, \snare, \hat].choose;
switch (hit)
    {\kick}    { "doof".postln; }
    {\snare}   { "baaa".postln; }
    {\hat}     { "tsss".postln; };
)

// case
(
var volume = 1.0.rand;
case
    {volume < 0.5}                     { "quiet".postln; }
    {volume >= 0.5 && volume < 0.75 }  { "medium".postln; }
    {volume >= 0.75}                   { "loud".postln; };
)





// Loops
// -----

// for exists, but rarely used
for(0, 9, {|i| ("loop" + i).postln; });

// easier to use .do
10.do {|i| ("loop" + i).postln; };


// forBy
forBy(0, 9, 2, {|i| i.postln; });

// array looping
[\kick, \snare, \kick, \snare].do {|item, i|
    i.postln;
    item.postln;
};

// array range looping
(0..9).do {|item, i|
    ["loop", i, item].postln;
};

// goodBye forBy :)
(0, 2..9).do {|item, i|
    ["loop", i, item].postln;
};









// Functions
// ---------

// define
f = {
    "I am a function".postln;
};

// run
f.();

// shorthand for
f.value;

// parameters
~print = {|thing|
    thing.postln;
};

~print.("yo");

// default parameters
f = {|one, two=10|
    [one, two].postln;
};

f.(5);
f.(5, 5);

// named parameters
f = {|one, two=10, three|
    [one, two, three].postln;
};

f.(10, three: 5);

// using named parameters
f = {|one, two, three, four|
    [one, two, three, four].postln;
};

// once named, always named
// error!
f.(5, 10, three:15, 20);

// order not important
f.(5, 10, four:20, three: 15);


// unknown number of arguments, array
f = {|...args|
    args.postln;
};

f.(1, 2, 3, 4, 5);

f = {|...sgra|
    sgra.postln;
};

f.([5, 4, 3, 2, 1]);

f = {|one...args|
    one.postln;
    args.postln;
};

f.(1, 2, 3, 4, 5);

// Returning values: last thing
// ----------------------------
~add = {|a, b|
    a + b;
};

~add.(10, 20);

// prevent returning
~time = SystemClock.seconds;
~update = {
    ~time = SystemClock.seconds;
    nil;
};



// "first class objects"
// ---------------------
// can be treated as any other object

// array of functions
[{"one".postln;}, {"two".postln;}, {"three".postln;}]

// using a closure
~functionFactory = {|mul|
    {|val|
        mul * val;
    }
};

f = ~functionFactory.(10);
f.(5);
