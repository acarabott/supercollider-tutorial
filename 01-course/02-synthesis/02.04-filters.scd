/* ============================================================ */
/* Filters                                                      */
/* ============================================================ */

// Great tools for sculpting sounds

// Probably familiar with Low Pass, High Pass, Band Pass filters

// Low Pass: passes through frequencies below the cutoff, cutting those above it

// High Pass: passes frequencies above the cutoff, cutting those above it

// Band Pass: passes frequencies at a given range, cutting above and below it

// in SC:
LPF;
HPF;
BPF;

// Most filters you've probably used have been resonant filters in SC these are
// These have an rq parameter: The reciprocal of Q.
// Q is conventionally defined as cutoffFreq / bandwidth
// rq = (bandwidth / cutoffFreq).

RLPF;
RHPF;
BPF; // already resonant

FreqScope.new;
{BPF.ar(WhiteNoise.ar(0.5), 800, MouseY.kr(1e-9, 1, 0).poll); }.play;
// Subtractive synthesis


// Let's write a SynthDef with a RLPF
SynthDef(\sawRes, { |freq=440, ffreq=1000, rq=0.2, mul=0.1, out=0|
    var sig = LFSaw.ar(freq, 0, mul);
    var filter = RLPF.ar(sig, ffreq, rq);

    Out.ar(out,
        filter.dup
    );
}).add;

x = Synth(\sawRes, [\freq, 440]);

MIDIdef.cc(\control, {|val, num|
    if(num == 7) {
        x.set(\ffreq, val.linexp(0, 127, 20, 20000));
    };
    [val, num].postln;
});

MIDIdef.noteOn(\noteOn, {|val, num|
    x.set(\freq, num.midicps);
    // TASK: velocity -> cutoff
    // x.set(\ffreq, val.linexp(0, 127, 100, 8000));
});
{end nostudent


// Lots more filters to be found in Help -> UGens -> Filters

// DFM1, Klank, DynKlank, MoogFF