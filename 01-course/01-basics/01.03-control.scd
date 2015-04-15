/* ============================================================ */
/* 03 Controlling Sound                                         */
/* ============================================================ */

// Mouse control
// -----------------------------------------------------------------------------

~mouse = { SinOsc.ar(MouseX.kr(220, 880), 0, 0.1); }.play;
~mouse = { SinOsc.ar(MouseX.kr(220, 880), 0, MouseY.kr(0, 0.1)); }.play;
~mouse = { SinOsc.ar(MouseX.kr(220, 880), 0, MouseY.kr(0, 0.1) * MouseButton.kr(0, 1)); }.play;
~mouse.free;

// Parameters
// -----------------------------------------------------------------------------

~mouse = {|minFreq=220, maxFreq=880|
    var freq = MouseX.kr(minFreq, maxFreq);
    var mul = MouseY.kr(0, 0.1) * MouseButton.kr(0, 1);
    SinOsc.ar(freq, 0, mul);
}.play;
~mouse.set(\minFreq, 440);
~mouse.set(\maxFreq, 1100);
~mouse.set(\minFreq, 220, \maxFreq, 880);
~mouse.free;

// MIDI control
// -----------------------------------------------------------------------------

// connect to all MIDI devices
MIDIIn.connectAll;

~tri = {|freq=440, mul=0.1| LFTri.ar(440, 0, 0.1) };

// A simple MIDIdef to print the velocity and key numbers pressed
MIDIdef.noteOn(\noteOnAction, {|vel, num|
    // convert MIDI numbers to frequency (cycles per second)
    // go back with .cpsmidi
    var freq = num.midicps;
    var mul = vel.linlin(0, 127, 0, 0.2);

    ~tri.set(\freq, freq, \mul, mul);
    [vel, num].postln;
});