/* ============================================================ */
/* Looping                                                      */
/* ============================================================ */


// A useful Synthdef
(
SynthDef(\sawPad) { |out=0, freq=440, mul=0.1, pan=0, att=0.2, sus=0.75, rel=1,
                     rate=0.5, fgain=2, madgain=0|

    var noise = LFNoise1.kr(0.3, 0.1, 0.1),
        saw     = Mix(VarSaw.ar(freq * [0.5, 1, 2], 0, noise, mul)),
        line    = Line.kr(20000, 100, att + sus + rel),
        moog    = MoogFF.ar(saw, SinOsc.kr(rate).range(400, 10000), fgain),
        madmoog = MoogFF.ar(saw, line, madgain).range(-0.1, 0.1),
        signal  = Mix([moog, madmoog]),
        env     = EnvGen.ar(Env.linen(att, sus, rel, 1, 'sine'), doneAction: 2);

    Out.ar(out,
        Pan2.ar(signal* env);
    );
}.add;
)

// Loops
// -----

{begin nostudent}
(
3.do {|i|
    Synth(\sawPad, [\freq, rrand(200, 2000)]);
};
)

(
{
    3.do {|i|
        Synth(\sawPad, [\freq, rrand(200, 2000)]);
        0.5.wait;
    };
}.fork;
)
{end nostudent}


// Array loops
// -----------

{begin nostudent}
(
[70, 74, 77].do {|item, i|
    Synth(\sawPad, [\freq, item.midicps]);
};
)

(
{
    [70, 74, 77, 81].do {|item, i|
        Synth(\sawPad, [\freq, item.midicps]);
        0.125.wait;
    };
}.fork;
)
{end nostudent}


// Infinite loops
// --------------

{begin nostudent}
(
{
    inf.do {|i|
        [70, 74, 77, 81, 84].do {|item, j|
            Synth(\sawPad, [
                \freq,    item.midicps,
                \att,     0.1,
                \sus,     0.1,
                \rel,     0.5,
                \rate,    4,
                \fgain,   rrand(0.1, 2),
                \madgain, [1, 4].choose
            ]);
            0.1.wait;
        };
    }
}.fork;
)
{end nostudent}