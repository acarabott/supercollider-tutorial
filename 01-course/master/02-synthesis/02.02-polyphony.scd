/* ============================================================ */
/* Polyphony                                                    */
/* ============================================================ */

// Make sure you have the \tri SynthDef ready
SynthDef(\tri, {|freq=440, mul=0.1, out=0|
    Out.ar(out,
        LFTri.ar(freq, 0, mul);
    );
}).add;


// Create a Synth with every noteOn
MIDIdef.noteOn(\polyTri, {|vel, num|
    {begin nostudent}
    Synth(\tri, [\freq, num.midicps, \mul, vel.linlin(0, 127, 0, 0.15)]);
    {end nostudent}
});

// Everything is eternal... we need some bookkeeping
{begin nostudent}
~synths = Array.newClear(128);
~synths = nil!80;

~synths[60] = ~synths[60] = Synth(\tri, [\freq, 60.midicps]);
~synths[60].free;

// Adjust the noteOn MIDIdef

MIDIdef.noteOff(\noteOffAction, {|vel, num|
    ~synths[num].free;
});
{end nostudent}