/* ============================================================ */
/* Task: Write a drum pattern                                   */
/* ============================================================ */

// Write a drum pattern consisting of at least one kick, snare and hat part
// can have multiple routines for each instrument!


// SynthDefs (with new clap);
(
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

SynthDef(\clap, {|out=0, amp = 0.5|
    var env1, env2, sig, noise1, noise2;

    env1 = EnvGen.ar(Env(
        [0, 1, 0, 1, 0, 1, 0, 1, 0],
        [0.001, 0.013, 0, 0.01, 0, 0.01, 0, 0.03],
        [0, -3, 0, -3, 0, -3, 0, -4]
    ));
    env2 = EnvGen.ar(Env([0, 1, 0], [0.02, 0.3], [0, -4]), doneAction:2);

    noise1 = WhiteNoise.ar(env1);
    noise1 = HPF.ar(noise1, 600);
    noise1 = BPF.ar(noise1, 2000, 3);

    noise2 = WhiteNoise.ar(env2);
    noise2 = HPF.ar(noise2, 1000);
    noise2 = BPF.ar(noise2, 1200, 0.7, 0.7);

    sig = noise1 + noise2;
    sig = sig * 2;
    sig = sig.softclip * amp;

    Out.ar(out, sig.dup);
}).add;
)