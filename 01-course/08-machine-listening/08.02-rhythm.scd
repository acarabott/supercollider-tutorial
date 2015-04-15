/* ============================================================ */
/* Machine Listening: Rhythm                                    */
/* ============================================================ */


// Onsets
// ------

SynthDef(\onsets, { |in=0, thresh=0.5, relax=1, out=0|
    var sig = SoundIn.ar(in);
    var fft = FFT(LocalBuf(512, 1), sig);
    var onsets = Onsets.kr(fft, thresh, \rcomplex, relax);

    SendReply.kr(onsets, '/onset', 1);
}).add;

x = Synth(\onsets, [\in, 0]);


OSCdef(\onsets, {|msg, time, addr, recvPort|
    {LFTri.ar(rrand(200, 800)) * EnvGen.ar(Env.perc, doneAction: 2) * 0.1}.play;
}, '/onset');




// Beat Tracking
// -------------

~apath = "~/Projects/15-04_resonate/workshop/audio/loops/amen.wav";
~abuf = Buffer.read(s, ~apath.standardizePath);

SynthDef(\beatTrack, { |buf=0, lock=0, rate=1, muls=#[0.3, 0.3, 0.3], out=0|
    var sig, fft;
    var trackb, trackh, trackq, tempo;
    var beeps;

    sig = PlayBuf.ar(2, buf, BufRateScale.kr(buf) * rate, loop:1);
    fft = FFT(LocalBuf(1024, 1), Mix(sig)); // convert to mono for tracking

    // returns multiple values, expand to variables with #
    #trackb, trackh, trackq, tempo = BeatTrack.kr(fft, lock);


    beeps = [[trackb, 500], [trackh, 1100], [trackq, 1500]].collect {|track, i|
        SinOsc.ar(track[1], 0, Decay.kr(track[0], 0.1, muls[i]));
    };

    (tempo * 60).poll;

    Out.ar(out,
        Mix(beeps) + sig;
    );
}).add;

// See also: BeatTrack2