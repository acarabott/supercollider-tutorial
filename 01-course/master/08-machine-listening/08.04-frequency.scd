/* ============================================================ */
/* Machine Listening: Frequency                                 */
/* ============================================================ */

// FFT
// ---

/*
Converts a window of signal (usually 512 to 4096 samples)
from "time domain" (amplitude over time)
to "frequency domain" (amount of energy at frequencies)

Needs to be a window of time as a signal needs to repeat to have a frequency

Allows for frequency analysis and *manipulation*
*/

b = Buffer.read(s, Platform.resourceDir +/+ "sounds/a11wlk01.wav");

SynthDef(\fft, { |buf=0, rate=1, out=0|
    var sig = PlayBuf.ar(1, buf, BufRateScale.kr(buf) * rate, loop: 1);
    var new = sig;

{begin nostudent}
    var fftsize = 512;
    // 0.5 hop size
    // 1 hann window type
    var fft = FFT(LocalBuf(fftsize, 1), sig, 0.5, 1);
    var new = IFFT(fft);

    // var unpack = UnpackFFT(fft, fftsize, 0, fftsize);
    // var magphases = Demand.kr(fft >= 0, 0, unpack);
    // var mags = magphases.select {|item, i| i.even; };
    // var alt = magphases.collect {|m|
    //     LinLin.kr(MouseY.kr(0, 1), 0, 1, m, m.sqrt);
    // };
    // var altmags = alt.select {|item, i| i.even; };
    // var pack = PackFFT(fft, fftsize, alt);
    // var new = IFFT(pack);

    // SendReply.kr(Impulse.kr(30), '/fft', [mags, altmags].flat);
{end nostudent}

    Out.ar(out,
        new.dup;
    );
}).add;

(
w = Window("bins", Rect(100, 100, 1024, 600)).front;
m = MultiSliderView(w, Rect(0, 0, 1024, 300));
m.size_(512);
m.thumbSize_(2);
n = MultiSliderView(w, Rect(0, 300, 1024, 300));
n.size_(512);
n.thumbSize_(2);
)

OSCdef(\fft, {|msg, time, addr, recvPort|
    {begin nostudent}
    var data = msg[3..];
    var mags = data[0..255];
    var alt = data[256..];

    {m.value_(mags)}.defer;
    {n.value_(alt)}.defer;
    {end nostudent}
}, '/fft');

x = Synth(\fft, [\buf, b]);


// Sub bands
// ---------

SynthDef(\fftbands, { |buf=0, mode=1, out=0|
    var sig = PlayBuf.ar(1, buf, BufRateScale.kr(buf), loop: 1);
    var fft = FFT(LocalBuf(1024, 1), sig, 0.5, 1);
    // divide into bands
    //    0 -   80
    //   80 -  250
    //  250 -  500
    //  500 - 2000
    // 2000 - samplerate / 2
    var powers = FFTSubbandPower.kr(fft, [80, 250, 500, 2000], scalemode: mode);

    SendReply.kr(Impulse.kr(30), '/bands', powers);

    Out.ar(out,
        sig.dup;
    );
}).add;

(
w = Window("bands", Rect(2000, 100, 600, 300)).front;
m = MultiSliderView(w, Rect(0, 0, 600, 300));
m.size_(5);
m.gap_(0);
m.thumbSize_(600/5);
)

OSCdef(\bands, {|msg, time, addr, recvPort|
    var bands = msg[3..];

    {m.value = bands}.defer;
}, '/bands');

x = Synth(\fftbands, [\buf, b]);
x.set(\mode, 2);




// MFCC
// ----
// Mel-Frequency Cepstrum Coefficients
// The mel (from melody) scale is a based on human perception
// Often used for timbre analysis, and speech recognition
~wePath = "~/Projects/15-04_resonate/workshop/audio/jeff-buckley/we02.aiff";
~ownPath = "~/Projects/15-04_resonate/workshop/audio/jeff-buckley/own04.aiff";

~we = Buffer.read(s, ~wePath.standardizePath);
~own = Buffer.read(s, ~ownPath.standardizePath);

SynthDef(\mfcc, { |buf=0, rate=1, out=0, mfccout=0|
    var sig = PlayBuf.ar(2, buf, BufRateScale.kr(buf) * rate, loop: 1);
    var fft = FFT(LocalBuf(512, 1), Mix(sig));

// {begin nostudent}
    var mfccs = MFCC.kr(fft, 13);
    Out.kr(mfccout, mfccs);
// {end nostudent}

    Out.ar(out,
        sig.dup;
    );
}).add;

(
w = Window("MFCCs", Rect(2000, 100, 600, 300)).front;
m = MultiSliderView(w, Rect(0, 0, 600, 300));
m.size_(12);
m.gap_(0);
m.thumbSize_(600/12);
)

~bus = Bus.control(s, 1);
x = Synth(\mfcc, [\buf, b, \mfccout, ~bus]);

Tdef(\mfccs, {
    inf.do {|i|
        ~bus.getn(13, {|msg|
            { m.value_(msg) }.defer;
        });
        0.05.wait;
    }
}).play;

x.set(\buf, ~own);
x.set(\buf, ~we);


// See also
// --------
SpecFlatness
SpecPcile
SpecCentroid

// Help -> UGens > Analysis