/* ============================================================ */
/* The Mighty SynthDef                                          */
/* ============================================================ */

// SynthDefs -> Synth analogous to Class -> Object
// One SynthDef, many Synths

{begin nostudent}
// So far we've been using a short cut method on a function
// {} is function
// Rewrite, still uses function
{end nostudent}

// old and busted
~tri = {|freq=440, mul=0.1| LFTri.ar(freq, 0, mul) }.play;

// new hotness
{begin nostudent}
SynthDef(\tri, {|freq=440, mul=0.1, out=0|
    Out.ar(out,
        LFTri.ar(freq, 0, mul);
    );
}).add;

// Break it down:
// -------------
// SynthDef : Class
// \tri     : SynthDef name, can be \Symbol or "String", Symbol stronger
// |args|   : same
// Out.ar   : previously taken care of for us
// .add     : method call that adds it to the Server
{end nostudent}

// Creating a Synth
{begin nostudent}
~tri = Synth(\tri, [\freq, 220, \mul, 0.05]);

50.do {
    Synth(\tri, [\freq, rrand(100, 5000), \mul, 0.01]);
};


{
    4.collect {|oct| oct * 12 + [60, 67, 68, 75] }.flat.do {|note|
        Synth(\tri, [\freq, note.midicps, \mul, 0.01]);
        0.1.wait;
    };
}.fork;

{end nostudent}

// Variables inside SynthDefs
// ---------------------------

{begin nostudent}
SynthDef(\ugly, { |out=0|
    Out.ar(out,
        RLPF.ar(LFSaw.ar(MouseX.kr(110, 880), 0, MouseY.kr(0.2, 0)), 800, 0.2);
    );
}).add;

SynthDef(\pretty, { |out=0|
    var freq    = MouseX.kr(110, 880);
    var mul     = MouseY.kr(0.2, 0);
    var saw     = LFSaw.ar(freq, 0, mul);
    var filter  = RLPF.ar(saw, 800, 0.2);

    Out.ar(out,
        filter
    );
}).add;
{end nostudent}

// Polling values in running Synths
// --------------------------------

// .poll(rate, label)
// SinOsc.ar(440, 0, 0.1).poll(30, "sine")



// Tracing Synths
// --------------

synth.trace;