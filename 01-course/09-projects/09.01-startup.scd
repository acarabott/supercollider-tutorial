/* ============================================================ */
/* Startup                                                      */
/* ============================================================ */

// Environments
// ------------
currentEnvironment;
topEnvironment;

// create a new environment
e = Environment.make {
    ~msg = "Created environment";
};

// what will the value of ~msg be?
~msg.postln;

// use the new environment
e.use {
    ~msg.postln;
};

// make the new environment the currentEnvironment
e.push;

// now this should work
~msg.postln;

// restore topEnvironment as currentEnvironment
e.pop;


// startup.scd
// -----------

// In the IDE open the File Menu > "Open startup file"

// The directory will be
Platform.userConfigDir

// So OS X this is ~/Library/Application Support/SuperCollider/startup.scd



s.options.sampleRate = 48000;
s.options.inDevice = "Built-in Input";
s.options.outDevice = "Built-in Output";
s.options.memSize = 2**19; // separate from memory used for Buffers
("Server running at: " ++ s.addr).postln;
("Language running on port:" ++ NetAddr.langPort).postln;

// declare a new environment
e = Environment.make {
    ~clock = TempoClock(2);

    ~four2floorFactory = {|synthDefName, buffer|
        Routine {
            inf.do {
                Synth(synthDefName, [\buf, buffer]);
                1.wait;
            };
        };
    };
};
e.push;

~kpath = "~/Projects/15-04_resonate/workshop/03-audio/drums/linndrum/kick.wav";
~kpath = ~kpath.standardizePath;

// do some stuff after we boot
s.waitForBoot {
    {
        SynthDef(\monoHit, {|buf=0, out=0|
            Out.ar(out,
                PlayBuf.ar(1, buf, BufRateScale.kr(buf), doneAction: 2);
            );
        }).add;
        ~kickBuf = Buffer.read(s, ~kpath);

        s.sync;
        ~kickRoutine = ~four2floorFactory.(\monoHit, ~kickBuf);
        ~kickRoutine.play(~clock);
    }.fork;
};



// Startup Class
// -------------

// add functions to happen after library is compiled, and startup.scd has run
*initClass {
    StartUp.add({
        "Class ready!".postln;
    });
}

// Can also add objects if they implement a doOnStartUp method


// ShutDown Class
// --------------
// not as cleanly implemented....
ShutDown.objects.add({ "hi" });