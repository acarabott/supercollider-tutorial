/* ============================================================ */
/* 02 First sounds                                              */
/* ============================================================ */

// Booting the server

{begin nostudent}
s.boot;
{end nostudent}

// Super B


// Our first sound

{begin nostudent}
{ SinOsc.ar(440, 0, 0.1) }.play;
{end nostudent}

// Stopping sounds
// OS X:    Cmd .
// Lin/Win: Ctrl .



// Seeing sounds
s.meter;         // Input / Output meters
s.makeWindow;    // Server Window: Master Volume, Mute, Boot and Record controls
s.scope;         // Oscilloscope
FreqScope.new;   // Frequency Analyser

{begin nostudent}
// SinOsc details, ar/kr, freq, phase, mul, add

// use this to show phase
{ SinOsc.ar(440, [0, pi], 0.1, 0) }.play;
{end nostudent}

// individual sounds

{begin nostudent}
a = { SinOsc.ar(440, 0, 0.1) }.play;
a.free;

// explain about global vars
{end nostudent}

// mouse control

{begin nostudent}
a = { SinOsc.ar(MouseX.kr(100, 1000), 0, 0.1) }.play;
{end nostudent}

// passing arguments

{begin nostudent}
a = {|mul=0.1| SinOsc.ar(MouseX.kr(100, 1000), 0, mul) }.play;
a.set(\mul, 0.2);
a.free;
{end nostudent}


// Get some chops, create a bunch of different sounds:

/*
Similar UGens to try:
  LFSaw
  LFTri
  LFCub
  LFPar

- Human hearing is 20-20,000Hz
- Keep the mul low, around 0.1

*/


/*
Simple noise generators, one param: mul (0.1)

WhiteNoise
BrownNoise
PinkNoise
ClipNoise

*/


/*
Complex noise generators.
Two params, control and mul

          // Useful ranges for first param
Crackle   // 1.0 - 2.0
Dust      // 10 - 10000
LFNoise0  // 10 - 2000

*/




// Recording it

{begin nostudent}
s.record;
s.stopRecording;
{end nostudent}



// A bigger example (to prove there's light at the end of the tunnel)

(
    // select all the code and run it
    // use mouse to strum strings
{
    var pitch, mousex, out;
    pitch = [ 52, 59, 66, 67, 71, 81 ];
    mousex = MouseX.kr;
    out = Mix.arFill(pitch.size, { arg i;
        var pos, trigger1, trigger2, pluck1, pluck2, period, string1, string2,
        delay, mix;

        pos = 0.25 + (i * 0.1);
        period = pitch.at(i).midicps.reciprocal;

        trigger1 = HPZ1.kr(mousex > pos).abs;
        pluck1 = PinkNoise.ar(Decay.kr(trigger1, 0.05));
        string1 = CombL.ar(pluck1, period, period, 4);

        trigger2 = HPZ1.kr(mousex > (pos + 0.015)).abs;
        pluck2 = PinkNoise.ar(Decay.kr(trigger2, 0.05));
        string2 = CombL.ar(pluck2, period/2, period/2, 4);

        mix = Mix([string1, string2]);
        delay = CombN.ar(mix, 0.2, 0.2, 2);
        mix = Mix([mix, delay * 0.2]);

        Pan2.ar(FreeVerb.ar(delay, 0.5, 0.9, 0.4), i * 0.2 - 0.5);
    });
    LPF.ar(out, 12000);

    LeakDC.ar(out);


}.play;
)