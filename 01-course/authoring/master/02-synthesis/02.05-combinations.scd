/* ============================================================ */
/* Combining sounds                                             */
/* ============================================================ */

// Mix
// ---

{begin nostudent}
SynthDef(\mix, { |freq=440, mul=0.1, nmul=0.1, out=0|
    var sine = SinOsc.ar(freq);
    var tri = LFTri.ar(freq * 1.01);
    var noise = WhiteNoise.ar(nmul);
    var mix = Mix([sine, tri, noise]);

    Out.ar(out,
        Pan2.ar(mix, 0) * mul
    );
}).add;

x = Synth(\mix, [\freq, 440]);
x.set(\freq, 300, \nmul, 0.2);
{end nostudent}

// Multichannel expansion
// ----------------------

// Passing an array to UGens (usually) results in one UGen for each value

{begin nostudent}
SynthDef(\expand, { |out=0|
    var tris = LFTri.ar([440, 442, 880], 0, 0.1);
    var mix = Mix(tris);

    Out.ar(out,
        mix.dup;
    );
}).add;
x = Synth(\expand);

// With a freq argument
SynthDef(\expand, { |freq=440, mul=0.1, out=0|
    var freqs = [1, 1.01, 1.5, 2, 0.6] * freq;
    var tris = LFTri.ar(freqs, 0, mul / freqs.size);
    var mix = Mix(tris);

    Out.ar(out,
        mix.dup;
    );
}).add;

x = Synth(\expand);

DotViewer.directory = "~/Desktop/".standardizePath;

DotViewer.draw(SynthDef(\expand, { |freq=440, mul=0.1, out=0|
    var freqs = [1, 1.01, 1.5, 2, 0.6] * freq;
    var tris = LFTri.ar(freqs, 0, mul / freqs.size);
    var mix = Mix(tris);

    Out.ar(out,
        mix.dup;
    );
}))
{end nostudent}