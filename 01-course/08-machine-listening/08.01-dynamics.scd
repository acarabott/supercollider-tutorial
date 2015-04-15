/* ============================================================ */
/* Machine Listening: Dynamics                                  */
/* ============================================================ */

// Amplitude
// ---------
SynthDef(\amp, { |in=0, att=0.01, rel=0.01, out=0|
    var sig = SoundIn.ar(in);
    var amp = Amplitude.kr(sig, att, rel);
    var chord = LFTri.ar([62, 65, 69].midicps, 0, amp);
    var mixed = Mix(chord);

    Out.ar(out,
        mixed.dup;
    );
}).add;

x = Synth(\amp, [\in, 0]);
x.set(\att, 0.5, \rel, 10);

// Server side scaling
// -------------------
SynthDef(\ampScale, { |in=0, att=0.01, rel=0.01, t_reset=0, out=0|
    var sig = SoundIn.ar(in);
    var amp = Amplitude.kr(sig, att, rel);
    var min = RunningMin.kr(amp, t_reset);
    var max = RunningMax.kr(amp, t_reset);
    var scaled = LinLin.kr(amp, min, max, 0, 0.1);
    var chord = LFTri.ar([62, 65, 69].midicps, 0, scaled);
    var mixed = Mix(chord);

    Out.ar(out,
        mixed.dup;
    );
}).add;

x = Synth(\ampScale, [\att, 0.5, \rel, 10]);





// Analysis
// --------
b = Buffer.read(s, Platform.resourceDir +/+ "sounds/a11wlk01.wav");

SynthDef(\dynamics, { |in=0, buf=0, mul=1, win=0.5, rate=20, decay=0.9, out=0|
    var sig = PlayBuf.ar(1, buf, BufRateScale.kr(buf), loop:1) * mul;
    var fft = FFT(LocalBuf(512, 1), sig);
    var amp = Amplitude.kr(sig, 0.5, 0.5);
    var wamp = WAmp.kr(sig, win);
    var loud = Loudness.kr(fft);
    var peak = Peak.ar(sig);
    var peakdec = PeakFollower.ar(sig, decay);

    var imp = Impulse.kr(rate);
    SendReply.kr(imp, '/dynamics', [amp, loud, wamp, peak, peakdec]);

    Out.ar(out,
        sig.dup;
    );
}).add;

OSCdef(\dynamics, {|msg, time, addr, recvPort|
    ["amp", "loud", "wamp", "peak", "peakdec"].do {|item, i|
        (item ++ ": ").post;
        msg[3 + i].postln;
    };
    "".postln;
}, '/dynamics');

x = Synth(\dynamics, [\in, 0]);
x.set(\decay, 0.999999);
x.free;



// DetectSilence
// -------------
SynthDef(\detect, { |freq=440, thresh=0.001, time=0.1, out=0|
    var sine = LFTri.ar(freq, 0, 0.1);
    var decay = Decay2.ar(Impulse.ar(0), 0.01, Rand(1, 3));
    var sig = sine * decay;

    DetectSilence.ar(sig, thresh, time, doneAction: 2);

    Out.ar(out,
        sig.dup;
    );

}).add;

s.makeWindow;
(
    ~win = Window("detect", Rect(100, 100, 400, 70)).front;
    ~win.addFlowLayout;
    ~degrees = Scale.harmonicMinor.degrees;
    ~probs = ~degrees.collect {|item, i| ~degrees.size - 0}.normalizeSum;
    ~root = 48;
    ~thresh = 0.001;
    ~threshSlider = EZSlider(
        ~win,
        280@20,
        "thresh",
        ControlSpec(0.001, 0.1, 'lin', 0.001),
        {|ez| ~thresh = ez.value; },
        ~thresh
    );
    ~time = 0.1;
    ~timeSlider = EZSlider(
        ~win,
        280@20,
        "time",
        ControlSpec(0, 0.1),
        {|ez| ~time = ez.value; },
        ~time;
    );
{
    inf.do {|i|
        var octave = [0, 12, 24].wchoose([0.7, 0.2, 0.1]);
        var note = ~root + octave + ~degrees.wchoose(~probs);
        Synth(\detect, [\freq, note.midicps, \thresh, ~thresh, \time, ~time]);
        0.125.wait;
    };
}.fork;
)

~thresh = 0.09;
s.makeWindow;