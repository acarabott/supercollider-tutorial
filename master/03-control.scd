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
a = {|mul=0.1| SinOsc.ar(MouseX.kr(100, 1000), 0, mul) }.play;
a.set(\mul, 0.2);
a.free;
{end nostudent}



Server.default.boot;