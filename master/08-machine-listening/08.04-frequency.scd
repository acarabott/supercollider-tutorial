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
    var fft = FFT(LocalBuf(fftsize, 1), sig);
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
w = Window("bands", Rect(100, 100, 1024, 600)).front;
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



// MFCC
// ----
// Mel-Frequency Cepstrum Coefficients
// The mel (from melody) scale is a based on human perception
// Often used for timbre analysis, and speech recognition

SynthDef(\mfcc, { |buf=0, rate=1, out=0, mfccout=0|
    var sig = PlayBuf.ar(1, buf, BufRateScale.kr(buf) * rate, loop: 1);
    var fft = FFT(LocalBuf(512, 1), sig);
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
x = Synth(\mfcc, [\buf, b]);


SpecFlatness
SpecPcile
SpecCentroid


// notes
// Buffer size determines number of bins (if hop == 1)
// can unpack with UnpackFFT
// custom bands with FFTSubbandPower
s.boot.doWhenBooted {
    var fftsize = 1024;
    b = Buffer.alloc(s, fftsize, 1);
    c = Buffer.read(s, Platform.resourceDir +/+ "sounds/a11wlk01.wav");
}

(
SynthDef(\fff, {
    var sig, chain, unp, mags;
//     sig = SinOsc.ar;
//     sig = PlayBuf.ar(1, c, BufRateScale.kr(c), loop: 1);
    // sig = SoundIn.ar(0);
    sig = SinOsc.ar(MouseX.kr(20, 20000, 1), 0, 0.1);
    chain = FFT(b, sig);

    // Using the frombin & tobin args makes it much more efficient, limiting analysis to the bins of interest
    unp = UnpackFFT(chain, b.numFrames, frombin: 0, tobin: 1024);

    // Demand some data from the unpacker.
    // NOTE: At present, Demand.kr is unable to handle more than 32 inputs,
    // so using frombin & tobin to limit the number of bins is compulsory.
    mags = Demand.kr(chain >= 0, 0, unp).select{|anunp, index|
//         anunp.poll(label:if(index % 2 == 0,  "Magnitude", "Phase")+(index/2).floor);

        index.even;
    };

    SendReply.kr(Impulse.kr(60), '/mags', mags);

    Out.ar(0,
        (sig*0.1).dup;
    );
}).add;


)
x = Synth(\fff);

x.free;
OSCdef(\fff, {|msg, time, addr, recvPort|
    var mags = msg[3..];

    {
        m.value_(mags);
    }.fork(AppClock);
}, '/mags');

