/* ============================================================ */
/* Buffers                                                      */
/* ============================================================ */

// An array of floats, in memory, that live on the server

// Most common use is to hold audio: loading audio files, recording audio input

// Loading an audio file
// ---------------------
{begin nostudent}
b = Buffer.read(s, Platform.resourceDir +/+ "sounds/a11wlk01.wav");
b = Buffer.read(s, Platform.resourceDir +/+ "sounds/a11wlk01.wav", action:{|buf|
    "Buffer loaded".postln;
    ("path: " + buf.path).postln;
    ("duration: " + buf.duration).postln;
    ("sampleRate: " + buf.sampleRate).postln;
    ("numChannels: " + buf.numChannels).postln;
});

b.play;
b.plot;
// lots more in Buffer help file

// Dialog
Buffer.loadDialog(s);
{end nostudent}

