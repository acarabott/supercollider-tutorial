/* ============================================================ */
/* Busses                                                       */
/* ============================================================ */

// Lives on the server, used to connect Synths
// Bus class is the client side representation
// Can run at audio rate (ar) or control rate (kr)

{begin nostudent}
~abus = Bus.audio(s, 1);  // 1 channel audio bus on default server
~cbus = Bus.contro(s, 1); // 1 channel control bus on default server
{end nostudent}

// We've actually already used busses.
// With default values, we are sending out on bus 0
SynthDef(\source, { |freq=440, out=0|
    Out.ar(out,
        LFTri.ar(freq, 0, 0.1);
    );
}).add;


// The first N audio busses are reserved for hardware input/output
{begin nostudent}
s.options.numOutputBusChannels;
s.options.numInputBusChannels;

~abus.index.postln; // next available bus
{end nostudent}


// Routing a signal
// ----------------
{begin nostudent}
SynthDef(\filter, { |in=0, rate=0.5, freq=200, rq=0.2, mul=1, out=0|
    var sig = In.ar(in, 1);
    var ffreq = LinExp.ar(SinOsc.ar(rate), -1, 1, freq, 5000);
    var filter = RLPF.ar(sig, ffreq, rq);

    Out.ar(out,
        filter * mul;
    );
}).add;

// Create Synths
~sig = Synth(\source);
~filter = Synth(\filter, [\in, ~abus]);

~sig.set(\out, ~abus);

s.makeWindow;

~filter.free;

~filter = Synth.after(~sig, \filter, [\in, ~abus]);
~sig2 = Synth.before(~filter, \source, [\freq, 523, \out, ~abus]);
{end nostudent}


// Master FX
// ---------
{begin nostudent}
SynthDef(\reverb, {|bus|
    var sig = In.ar(bus, 2);
    var verb = GVerb.ar(sig);
    ReplaceOut.ar(bus, verb);
}).add;

r = Synth.after(~filter, \reverb, [\bus, 0]);
{end nostudent}