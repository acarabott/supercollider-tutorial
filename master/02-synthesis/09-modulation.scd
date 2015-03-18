/* ============================================================ */
/* Modulation                                                   */
/* ============================================================ */

// A fancy way of saying "varying something".
// Often modulation is done with LFOs: Low Frequency Oscillators
// i.e. Oscillator UGens (SinOsc, LFSaw etc) with freq at 0.001 - 10Hz


// Ring Modulation
// ---------------
{begin nostudent}
Ndef(\ring, {|carrFreq=220|
    var mod = SinOsc.ar(10, 0, 1);
    SinOsc.ar(carrFreq * mod, 0, 0.1).dup;
}).play(0, 2);
{end nostudent}



// Amplitude Modulation
// --------------------
{begin nostudent}
Ndef(\am, {
    // var mod = 0.1;
    // var mod = Line.kr(0, 0.1, 1);
    // var mod = EnvGen.kr(Env([0, 0.1, 0], [1, 2], \sin));
    var mod = SinOsc.kr(0.1, 0, 0.1); // wub: 3, weird: 10, rich: 100v
    mod.poll;
    SinOsc.ar(440, 0, mod).dup;
}).play(0, 2);
{end nostudent}
// Note that "true" amplitude modulation only uses positive values (unipolar)
// We'll learn about how to achieve that in the next example as it's clearer



// Frequency Modulation
// --------------------

// Only getting positive values from a modulator
{begin nostudent}
Ndef(\fm, {
    // var freq = SinOsc.kr(1, 0, 1); // .poll; what's the range?

    // var max = 440;
    // var min = 220;
    // var move = (max - min) / 2;
    // var mid = min + move;
    // var freq = SinOsc.kr(1, 0, 110, 330).poll(label:"freq"); // 1 - 2
    // freq: 200 nice
    // SinOsc.ar(freq, 0, 0.1).dup;
}).play(0, 2);
{end nostudent}



// Rich DX7 Style FM
// -----------------
{begin nostudent}
Ndef(\fm, {|carrFreq=440, modFreq=100, modDepth=100|
    var mod = SinOsc.ar(modFreq) * modDepth; // demo difference ar kr
    var freq = carrFreq + mod;
    SinOsc.ar(freq, 0, 0.1).dup;
}).play(0, 2);

MIDIdef.cc(\control, {|val, num|
    if(num == 10) {
        Ndef(\fm).set(\modFreq,  val.linexp(0, 127, 20, 5000));
    };
    if(num == 7) {
        Ndef(\fm).set(\modDepth, val.linexp(0, 127, 0.01, 5000));
    };
    [val, num].postln;
});
{end nostudent}


// The more friendly modulation index
{begin nostudent}
Ndef(\fm, {|carrFreq=440, modFreq=1, modIndex=0|
    var mod = modIndex * modFreq * SinOsc.ar(modFreq);
    SinOsc.ar(carrFreq + mod, 0, 0.1).dup;
}).play(0, 2);

MIDIdef.cc(\control, {|val, num|
    if(num == 10) {
        Ndef(\fm).set(\modFreq,  val.linexp(0, 127, 20, 5000));
    };
    if(num == 7) {
        Ndef(\fm).set(\modIndex, val.linlin(0, 127, 0.01, 20));
    };
    [val, num].postln;
});
{end nostudent}




// Phase Modulation
// ----------------

// Can you implement it?