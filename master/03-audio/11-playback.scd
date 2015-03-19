/* ============================================================ */
/* Buffer Playback                                              */
/* ============================================================ */

// PlayBuf
// --------
{begin nostudent}
SynthDef(\playbuf, { |buf=0, out=0|
    var sig = PlayBuf.ar(1, buf, BufRateScale.kr(buf));

    Out.ar(out,
        Pan2.ar(sig, 0)
    );
}).add;

x = Synth(\playbuf, [\buf, b]);

// stereo
// trigger
// doneAction
// rate
// looping
{end nostudent}

/*
A note on reverse single shots..

doneAction gets triggered when the play head is >= number of samples.
If you are starting at sample 0, and going backwards, you will hit this
sample and trigger the doneAction

To avoid this, you must start at the penultimate sample, which you can get with
b.numFrames - 2
*/



// LoopBuf
// -------

{begin nostudent}
~dpath = "~/Projects/15-04_resonate/workshop/master/03-audio/audio/drums.wav";
~drumBuf = Buffer.read(s, ~dpath.standardizePath);

SynthDef(\looper, {|buf=0, rate=1, gate=1, startPos=0, startLoop=0, endLoop=0,
                    pan=0, out=0|

    var sig = LoopBuf.ar(1,
                         buf,
                         BufRateScale.kr(buf) * rate,
                         gate,
                         startPos,
                         startLoop,
                         endLoop, // BufFrames.kr(buf)
                         4);

    Out.ar(out,
        Pan2.ar(sig, pan);
    );
}).add;

x = Synth(\looper, [
    \buf, ~drumBuf,
    \startPos, 0,
    \startLoop, 0,
    \endLoop, ~drumBuf.numFrames,
]);

x.set(\rate, 1);

x.set(\startLoop, 0, \endLoop, ~drumBuf.numFrames * 0.5 / 1);

{end nostudent}


// BufRd
// -----

// Greater control over playhead

{begin nostudent}
SynthDef(\bufrd, { |buf=0, start=0, end=44100, reset=0, t_trig=1, out=0|
    var phase = Phasor.ar(t_trig, BufRateScale.kr(buf), start, end, reset);
    // var phase = K2A.ar(MouseX.kr(start, end).lag);
    // var range = (end - start) / 2;
    // var phase = SinOsc.ar(0.1, 0, range, range).poll;
    var sig = BufRd.ar(1, buf, phase, 1);

    Out.ar(out,
        sig.dup;
    );
}).add;

x = Synth(\bufrd, [\buf, ~drumBuf, \start, 0, \end, ~drumBuf.numFrames]);
x.set(\t_trig, 1, \reset, 0);
x.free;
{end nostudent}

// DiskIn
// ------

// Using a Buffer to stream large audio files from disk

{begin nostudent}
SynthDef(\diskin, { |buf=0, out=0|
    var sig = DiskIn.ar(2, buf);

    Out.ar(out,
        sig;
    );
}).add;

~gpath = "~/Projects/15-04_resonate/workshop/master/03-audio/audio/guitar.wav";
~guitarBuf = Buffer.cueSoundFile(
    server: s,
    path: ~gpath.standardizePath,
    startFrame: 0,
    numChannels: 2,
    bufferSize: 2**18
);

x = Synth(\diskin, [\buf, ~guitarBuf]);
{end nostudent}
