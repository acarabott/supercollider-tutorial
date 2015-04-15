/* ============================================================ */
/* Other communication                                          */
/* ============================================================ */

// MIDI
// ----

// We have already received MIDI with MIDIdefs

MIDIClient.init;
MIDIIn.connectAll;

MIDIdef.noteOn(\noteOn, {|val, num, chan, src|
    num.postln;
});

// We can also send with MIDIOut (see help for more details)

MIDIClient.destinations;
// On OS X create an internal MIDI app with
// /Applications/Utilities/Audio MIDI Setup.app
m = MIDIOut.newByName("IAC Driver", "Bus 1");

// latency matches Server default
m.latency;
// can be reduced (often advisable)
m.latency = 0;

// send noteOn/noteOff
m.noteOn(chan: 0, note: 60, veloc: 100);
m.noteOff(0, 60, 100);

// all notes off
m.allNotesOff(chan: 0);

// send control messages
m.control(0, 7, 100);



// Serial
// ------

SerialPort.openHelpFile;

// Arduino
// -------

// Can be achieved with SerialPort, but Arduino specific Quark available
Quarks.gui;



// Audio
// -----

// OS X
// -----
// Use SoundFlower to route audio between Applications
// Binary: http://rogueamoeba.com/freebies/soundflower/
// Source: https://github.com/RogueAmoeba/Soundflower

// Linux, Windows (and OS X)
// -------------------------
// JACK: http://jackaudio.org/downloads/