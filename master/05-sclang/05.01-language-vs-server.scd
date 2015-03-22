/* ============================================================ */
/* Language vs Server                                           */
/* ============================================================ */

// SuperCollider has three primary components:
// IDE
// sclang
// scsynth


// IDE
// ---

// Tool for writing code

// sclang
// ------

// Expressive language, with musical semantics (Tempo, Scale, wait etc)
// Good for high level abstraction, logic and handling data

// scsynth
// --------

// Optimised audio engine
// Efficient DSP
// A bit of a grey-box



// sclang / scsynth relationship somewhat analogous to CPU / GPU in graphics


"Client vs Server".openHelpFile;




// Lang -> Server Communication
// ----------------------------

// Sending a SynthDef to the server
SynthDef(\basic, { |freq=440, mul=0.1, out=0|
    Out.ar(out,
        SinOsc.ar(freq) * mul * EnvGen.ar(Env.perc, doneAction:2);
    );
}).add;

// Creating a Synth on the server
Synth(\basic, [\freq, 800]);

// Allocating a 1 second stereo buffer on the server
Buffer.alloc(s, s.sampleRate, 2);


// Slight latency
// --------------

// Ensures more reliable timing
// Timestamped OSC messages can ensure better timing.
// Can be reduced, will see "late" messages with v.low values
s.latency.postln;



// Ensuring synchronisation
// ------------------------

// even if run at the same time, timing not guaranteed on server
Synth(\basic, [\freq, 440, \mul, 0.2]);
Synth(\basic, [\freq, 660, \mul, 0.2]);
// Generally this is ok


// guaranteed to run within same cycle on server
s.bind {
    Synth(\basic, [\freq, 440, \mul, 0.2]);
    Synth(\basic, [\freq, 660, \mul, 0.2]);
};

// under the hood
s.makeBundle(2.0, {
    Synth(\basic, [\freq, 440, \mul, 0.2]);
    Synth(\basic, [\freq, 660, \mul, 0.2]);
});




// Multiple Servers
// ----------------

~s2 = Server(\server2, NetAddr("127.0.0.1", 57112));
~s2.boot;

s.makeWindow;
~s2.makeWindow;

Synth(\basic, [\freq, 440], ~s2);




// Server -> Lang communication
// ----------------------------


// .poll / SendReply
// -----------------
x = { SinOsc.ar(440, 0, 0.1).poll(20, "sine mul"); }.play;

// Under the hood
SynthDef(\poll, { |freq=440, mul=0.1, rate=10, out=0|
    var sig = SinOsc.ar(freq);

    var imp = Impulse.kr(rate);

    SendReply.kr(imp, '/sineMul', [sig]);

    Out.ar(out,
        sig.dup * mul;
    );
}).add;

OSCdef(\muldef, {|msg, time, addr, recvPort|
    msg.postln;
}, '/sineMul');

x = Synth(\poll, [\freq, 220]);

get

// .get
// ----

// asynchronous, uses callback

// Synth
// -----
x = Synth(\poll, [\freq, 220]);
x.get(\mul, {|msg| msg.postln});

// Buffer
// ------
b = Buffer.read(s, Platform.resourceDir +/+ "sounds/a11wlk01.wav");
b.get(44100, {|msg| msg.postln; });
b.getn(44100, 20, {|msg| msg.postln; });

// for ranges > 1633
b.loadToFloatArray(44100, 2000, {|array| {array.plot;}.defer; });


// Bus (more on these later)
// ----
x = Synth(\poll, [\freq, 220]);
~bus = Bus.control(s);
~bus.value = 400;

x.map(0, ~bus);
~bus.get({|msg| msg.postln});
