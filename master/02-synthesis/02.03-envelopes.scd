/* ============================================================ */
/* Envelopes                                                    */
/* ============================================================ */

{begin nostudent}
// Might have noticed a click when freeing Synth
// occurs with very fast transition, can be artistic
Env([0, 1, 0, 0], [2, 0, 2]).test.plot

// May be familiar with envlopes like ADSR
Env.adsr.plot;
Env.adsr.test;
Env.perc.test.plot;

{end nostudent}

// Defined by levels and times
// ---------------------------
{begin nostudent}
Env([0, 1, 0], [0.5, 1]).plot;
{end nostudent}

// Somewhat analogous to vector graphics
// Can convert to concrete set of values (like bitmap)
Env([0, 1, 0], [0.5, 1]).asSignal(100)


// Segments curves
// ---------------
{begin nostudent}
Env([0, 1, 0], [0.5, 1], \sin).plot;
Env([0, 1, 0], [0.5, 1], [\sin, \exp]).plot;
// Show help file
{end nostudent}


// Within a SynthDef: EnvGen
// -------------------------
{begin nostudent}
SynthDef(\envTri, {|freq=440, mul=0.1, out=0|
    var sig = LFTri.ar(freq, 0, mul);
    var env = EnvGen.ar(Env([0, 1, 0], [0.5, 1], \sin));

    Out.ar(out,
        sig * env;
    );
}).add;

~env = Synth(\tri, [\freq, 440]);

// Synth still there, prove with
s.makeWindow;
// add doneAction: 2
{end nostudent}

// Update our MIDIdef
{begin nostudent}
MIDIdef.noteOn(\noteOnAction, {|vel, num|
    Synth(\envTri, [\freq, num.midicps, \mul, vel.linlin(0, 127, 0, 0.15)]);
});
{end nostudent}




// Sustained Envelopes
// -------------------
{begin nostudent}
SynthDef(\susTri, { |freq=440, mul=0.1, gate=1, out=0|
    var sig = LFTri.ar(freq, 0, mul);
    var env = EnvGen.ar(Env([0, 1, 0], [0.5, 1], \sin), gate);

    Out.ar(out,
        sig * env;
    );
}).add;

~synths = nil!128;

MIDIdef.noteOn(\noteOnAction, {|vel, num|
    ~synths[num] = Synth(\susTri, [
        \freq, num.midicps,
        \mul,  vel.linlin(0, 127, 0, 0.15)
    ]);
});

MIDIdef.noteOff(\noteOffAction, {|vel, num|
    ~synths[num].set(\gate, 0);
});
{end nostudent}



// Release and Loop Nodes
// ----------------------
{begin nostudent}
// releaseNode
var env = EnvGen.ar(Env([0, 1, 0.2, 0], [0.05, 2, 0.5], \sin, 2), gate);

// loopNode
// Note that the starting point for a segment is where you are *now*
// so when we release, it is *not* the release node volume
Env([0, 1, 0.2, 1, 0], [0.05, 1, 1, 0.5], \sin, 3, 1).plot;
var env = EnvGen.ar(Env([0, 1, 0.2, 1, 0], [0.05, 1, 1, 0.5], \sin, 3, 1));
{end nostudent}



// Retriggering Envelopes
// ----------------------
{begin nostudent}
SynthDef(\trigTri, { |freq=440, mul=0.1, t_gate=1, out=0|
    var sig = LFTri.ar(freq, 0, mul);
    // 1: no re-attack
    var env = EnvGen.ar(Env([0, 1, 0], [0.05, 2], \sin), t_gate);
    // 2: click
    // var env = EnvGen.ar(Env([0, 0, 1, 0], [0, 0.05, 2], \sin), t_gate);
    // 3: just right
    // var env = EnvGen.ar(Env([0, 0, 1, 0], [0.01, 0.05, 2], \sin), t_gate);

    Out.ar(out,
        sig * env;
    );
}).add;

x = Synth(\trigTri, [\freq, 440]);
x.set(\t_gate, 1);
{end nostudent}
