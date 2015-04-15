/* ============================================================ */
/* Buffers                                                      */
/* ============================================================ */

// An array of floats, in memory, that lives on the server

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
b.free;
// lots more in Buffer help file

// Can generate buffers (sine etc)

// Drag audio file to document

// Dialog
Buffer.loadDialog(s);
{end nostudent}
