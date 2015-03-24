MFCC
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

w = Window("bands", Rect(100, 100, 1800, 300)).front;
m = MultiSliderView(w, Rect(0, 0, 1800, 300));
m.size = 1024;

m.thumbSize_(1)