/* ============================================================ */
/* Machine Listening: Rhythm                                    */
/* ============================================================ */


// Onsets
// ------

{begin nostudent}
SynthDef(\onsets, { |in=0, thresh=0.5, relax=1, out=0|
    var sig = SoundIn.ar(in);
    var fft = FFT(LocalBuf(512, 1), sig);
    var onsets = Onsets.kr(fft, thresh, \rcomplex, relax);

    SendReply.kr(onsets, '/onset', 1);
}).add;

x = Synth(\onsets, [\in, 0]);
{end nostudent}


OSCdef(\onsets, {|msg, time, addr, recvPort|
    {LFTri.ar(rrand(200, 800)) * EnvGen.ar(Env.perc, doneAction: 2) * 0.1}.play;
}, '/onset');




BeatTrack
Onsets
BeatTrack2
