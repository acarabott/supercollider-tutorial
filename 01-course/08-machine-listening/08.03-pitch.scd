/* ============================================================ */
/* Machine Listening: Pitch                                     */
/* ============================================================ */


// Pitch detection
// ---------------
SynthDef(\pitch, { |in=0, out=0|
    var src, freq, hasFreq;
    var sig, mul;

    src = SoundIn.ar(in);
    // frequency and confidence
    #freq, hasFreq = Tartini.kr(src);

    // conditionals result in 0 or 1
    mul = 0.1 * (freq > 60) * (freq < 20000);

    freq.poll(label:"freq");
    hasFreq.poll(label:"hasFreq");
    mul.poll(label:"mul");
    sig = LFSaw.ar(freq, 0, mul.lag(0.1, 0.3));

    Out.ar(out,
        sig.dup;
    );
}).add;

x = Synth(\pitch, [\in, 0]);


// Combine with Amplitude
// ----------------------
// Adapted from the Tartini help file
SynthDef(\follower, {|in=0, att=0.05, rel=0.2, autotune=0, out=0|
    var src, amp, freq, hasFreq, auto, sig;

    src = SoundIn.ar(in);
    amp = Amplitude.kr(src, att, rel);
    # freq, hasFreq = Tartini.kr(src, 0.93, 1024, 512, 512);
    auto = Lag.kr(freq.cpsmidi.round(1).midicps, 0.05);
    freq = Select.kr(autotune, [freq, auto]);
    sig = Mix(
        VarSaw.ar(
            freq * [0.5, 1, 2],
            0,
            LFNoise1.kr(0.3, 0.1, 0.1),
            amp
        )
    );

    6.do {
        sig = AllpassN.ar(sig, 0.040, [0.040.rand, 0.040.rand], 2)
    };

    Out.ar(out,
        sig.dup
    );
}).add;

x = Synth(\follower);
x.set(\autotune, 1);
x.free

// Combine with Onsets
// -------------------

SynthDef(\guitar, { |in=0, thresh=0.5, relax=1, del=0.1, out=0|
    var sig = SoundIn.ar(in);
    var fft = FFT(LocalBuf(512, 1), sig);
    var onsets = Onsets.kr(fft, thresh, \wphase, relax);
    var freq, hasFreq;

    #freq, hasFreq = Tartini.kr(sig, 0.93, 1024, 512, 512);

    SendReply.kr(TDelay.kr(onsets, del), '/note', [freq, hasFreq]);

    Out.ar(out,
        sig;
    );
}).add;

OSCdef(\guitar, {|msg, time, addr, recvPort|
    msg[3].cpsmidi.round(1).postln;
}, '/note');

x = Synth(\guitar);


// KeyTrack
// --------

// Output:
// 0-11 C major to B major
// 12-23 C minor to B minor.

// Adapted from KeyTrack help file
SynthDef(\keytrack, { |out=0|
    var sig, fft, key;

    sig = Mix(SinOsc.ar((60 + [0, MouseX.kr(3, 4).round(1), 7]).midicps));
    fft = FFT(LocalBuf(4096, 1), sig);
    key = KeyTrack.kr(fft);
    key.poll(label:"key");

    Out.ar(0,
        sig.dup;
    );
}).add;

x = Synth(\keytrack);