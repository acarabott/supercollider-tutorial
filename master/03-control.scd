/* ============================================================ */
/* 03 Controlling Sound                                         */
/* ============================================================ */

// mouse control

{begin nostudent}
a = { SinOsc.ar(MouseX.kr(220, 880), 0, 0.1); }.play;
a = { SinOsc.ar(MouseX.kr(220, 880), 0, MouseY.kr(0, 0.1)); }.play;
a = { SinOsc.ar(MouseX.kr(220, 880), 0, MouseY.kr(0, 0.1) * MouseButton.kr(0, 1)); }.play;
a.free;
{end nostudent}

// setting via parameters

{begin nostudent}
a = {|minFreq=220, maxFreq=880|
    var freq = MouseX.kr(minFreq, maxFreq);
    var mul = MouseY.kr(0, 0.1) * MouseButton.kr(0, 1);
    SinOsc.ar(freq, 0, mul);
}.play;
a.set(\minFreq, 440);
a.set(\maxFreq, 1100);
a.set(\minFreq, 220, \maxFreq, 880);
a.free;
{end nostudent}