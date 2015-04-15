/* ============================================================ */
/* Synchronisation                                              */
/* ============================================================ */


(
// Useful SynthDefs
// ----------------
// Some drum synths for your pleasure and later analysis....
// adapted from the acid_otophilia example

SynthDef(\hat, {|freq=4000, rel=0.125, mul=1, out=0|
    var white = WhiteNoise.ar(1),
    hpf = HPF.ar(white, freq),
    lpf = LPF.ar(hpf, freq+200),
    env = EnvGen.ar(Env.perc(0.01, rel), doneAction:2),
    hit = lpf* env;

    hit = hit * 1.5;
    hit = hit.clip2(1);

    Out.ar(out,
        Pan2.ar(hit * mul)
    );
}).add;

SynthDef(\kick, {|mul=0.5, out=0|
    var env0, env1, env1m, sig;

    env0 =  EnvGen.ar(Env([0.5, 1, 0.5, 0], [0.005, 0.06, 0.26], [-4, -2, -4]),
                      doneAction:2);
    env1 = EnvGen.ar(Env([110, 59, 29], [0.005, 0.29], [-4, -5]));
    env1m = env1.midicps;

    sig = LFPulse.ar(env1m, 0, 0.5, 1, -0.5);
    sig = sig + WhiteNoise.ar(1);
    sig = LPF.ar(sig, env1m*1.5, env0);
    sig = sig + SinOsc.ar(env1m, 0.5, env0);

    sig = sig * 1.2;
    sig = sig.clip2(1);

    Out.ar(out,
        Pan2.ar(sig * mul);
    );
}).add;

SynthDef(\snare, {|out=0, mul=0.8|
    var env0, env1, env2, env1m, oscs, noise, sig;

    env0 = EnvGen.ar(Env([0.5, 1, 0.5, 0], [0.005, 0.03, 0.10], [-4, -2, -4]));
    env1 = EnvGen.ar(Env([110, 60, 49], [0.005, 0.1], [-4, -5]));
    env1m = env1.midicps;
    env2 = EnvGen.ar(Env([1, 0.4, 0], [0.05, 0.13], [-2, -2]), doneAction:2);

    oscs = LFPulse.ar(env1m, 0, 0.5, 1, -0.5) +
           LFPulse.ar(env1m * 1.6, 0, 0.5, 0.5, -0.25);

    oscs = LPF.ar(oscs, env1m*1.2, env0);
    oscs = oscs + SinOsc.ar(env1m, 0.8, env0);

    noise = WhiteNoise.ar(0.2);
    noise = HPF.ar(noise, 200, 2);
    noise = BPF.ar(noise, 6900, 0.6, 3) + noise;
    noise = noise * env2;

    sig = oscs + noise;
    sig = sig.clip2(1);

    Out.ar(out,
        Pan2.ar(sig * mul);
    );
}).add;
)


// Clocks
// ------

// Routines are played on Clocks:
TempoClock;  // default, accurate, tempo based
SystemClock; // accurate, time based
AppClock;    // less accurate, used for GUI updates



// Global default TempoClock
// -------------------------
TempoClock.default;
TempoClock.default.tempo; // 1 == 60bpm, 1 beat per second
TempoClock.default.beatsPerBar;
TempoClock.default.beatDur;



// A clock of our very own
// -----------------------
t = TempoClock(2); // 2 == 120bpm, 2 beats per second



// BPM to Beats Per Second
// ---------------
~tempo = 135;
~tempo / 60;



// Playing a routine on a clock
// ----------------------------
~kick = Routine {
    inf.do {|i|
        Synth(\kick);
        1.wait;
    };
};

~kick.play(t);
t.tempo = 160 / 60;
t.tempo = t.tempo * 2;
t.tempo = t.tempo / 2;

CmdPeriod.run;

t = TempoClock(2);
t.permanent = true;
~kick.play(t);



// Add another routine
// -------------------

~hats = Routine {
    inf.do {|i|
        Synth(\hat);
        0.5.wait;
    };
};

~hats.play(t);
~hats.stop;


// Quantisation
// ------------

// Multiples of 4
~simpleKick = Routine {
    inf.do {|i|
        Synth(\kick);
        t.beats.postln;
        4.wait;
    };
};

~simpleKick.play(t, 4);

~simpleHats = Routine {
    inf.do {|i|
        Synth(\hat);
        4.wait;
    };
};

~simpleHats.play(t, 4);
~simpleHats.stop;

// Multiples of 1
~moreHats = Routine {
    inf.do {|i|
        Synth(\hat);
        1.wait;
    };
};

~moreHats.play(t, 1);
~moreHats.stop;


// Quant class
// -----------

// Values automatically converted to Quant
//               1 -> Quant(1.0, nil, nil);
//      [4.0, 1.0] -> Quant(4.0, 1.0, nil);
// [4.0, 1.0, 0.1] -> Quant(4.0, 1.0, 0.1);
//             nil -> Quant(nil, nil, nil); // default

// quant, phase, timingOffset

t.tempo = 1;

~conductor = Routine {
    inf.do {|i|
        (t.beatInBar + 1).asString.speak;
        1.wait;
    };
};

~conductor.play(t, 1);

~snare = Routine {
    inf.do {|i|
        Synth(\snare);
        4.wait;
    };
};

// Could play on 1 or 3
~snare.play(t, 2);
~snare.stop;

// On the 3
~snare.play(t, Quant(4, 2));

// Fix the timingOffset
// Documentation says for patterns only but....
~snare.play(t, Quant(4, 2, -0.2));


// Scheduling single events
// ------------------------

// Relative
(
var start = t.beats;
t.sched(1, {|beats, time, clock|
    [clock, time, start, beats - start].postln;
    nil; // prevent reschedling
});
)

// reschedules itself as postln returns the value
t.sched(1, {|beats, time, clock|
    1.postln;
});

// Absolute
t.schedAbs(t.beats + 2, { "two".postln; });
t.schedAbs(t.nextTimeOnGrid(2), { "same".postln; });
t.schedAbs(t.nextBar, {"bar".postln});
t.playNextBar({"ez".postln;});


// Changing beats per bar
// ----------------------

t.schedAbs(t.nextBar, {t.beatsPerBar_(5)});
t.beatsPerBar;