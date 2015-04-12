/* ============================================================ */
/* Buffer Recording                                             */
/* ============================================================ */

// BufWr
// -----
{begin nostudent}
SynthDef(\bufwr, { |in=0, buf=0, out=0|
    var input = SoundIn.ar(in);
    var phase = Phasor.ar(0, BufRateScale.kr(buf), 0, BufFrames.kr(buf));
    var rec = BufWr.ar(input, buf, phase, 0);

    FreeSelf.kr(Done.kr(rec));

    Out.ar(out,
        input.dup;
    );
}).add;

b = Buffer.alloc(s, s.sampleRate * 4, 1, {|buf| "alloc".postln; });
x = Synth(\bufwr, [\buf, b]);
s.makeWindow;
b.play;
{end nostudent}


// DiskOut
// -------

SynthDef(\diskout, { |buf=0, out=0|
    var sig = DynKlank.ar(`[
            [62, 69, 78, 80, 85].midicps,
            {SinOsc.kr(rrand(5, 10), 2pi.rand, 0.5, 0.5)}!5,
            {SinOsc.kr(rrand(0.1, 0.3), 2pi.rand, 0.5, 1)}!5
        ],
        Dust.ar(20, 0.1)
    );

    // Your DiskOut code here
    {begin nostudent}
    DiskOut.ar(buf, sig.dup);
    {end nostudent}

    // Not essential, but so we can hear it
    Out.ar(out,
        sig.dup;
    );
}).add;

// allocate buffer
{begin nostudent}
b = Buffer.alloc(s, (10 * s.sampleRate).nextPowerOfTwo, 2);
{end nostudent}

// create an output file for this buffer, leave it open
{begin nostudent}
b.write("~/test.aiff".standardizePath, "aiff", "int16", 0, 0, true);
{end nostudent}

// Create the synth
{begin nostudent}
x = Synth(\diskout, [\buf, b]);
{end nostudent}

// free synth
{begin nostudent}
x.free;
{end nostudent}

// close buffer and soundfile
{begin nostudent}
b.close;
{end nostudent}

// play the buffer
{begin nostudent}
b.play;
{end nostudent}

// free the buffer
{begin nostudent}
b.free;
{end nostudent}
