/* ============================================================ */
/* Classes                                                      */
/* ============================================================ */

Drummer : Object {
    classvar < synthdefs;
    classvar < synthdefsAdded;

    var <> name;
    var <  path;
    var <  server;

    var    buffers;
    var <> vol;

    *initClass {
        synthdefsAdded = false;
        this.createSynthDefs();
    }

    *createSynthDefs {
        synthdefs = [1, 2].collect {|nc|
            var name = ("drummer_" ++ nc);

            SynthDef(name, {|buf=0, mul=1, pan=0, out=0|
                var sig;
                sig = PlayBuf.ar(nc, buf, BufRateScale.kr(buf), doneAction:2);

                Out.ar(out,
                    Pan2.ar(sig, pan, mul);
                );
            });
        };
    }

    *addSynthDefs {
        if(synthdefsAdded) {
            ^nil;
        };

        if(synthdefsAdded.not) {
            this.synthdefs.do {|synthdef|
               synthdef.add;
            };
            synthdefsAdded = true;
        }
    }

    *new {|aName, aAudioPath, aServer|
        aServer = aServer ?? {Server.default};
        ^super.new.init(aName, aAudioPath, aServer);
    }

    init {|aName, aAudioPath, aServer|
        name = aName;
        path = aAudioPath;
        server = aServer;

        server.waitForBoot {
            buffers = this.loadBuffers(path, server);
            this.class.addSynthDefs;
        };
        vol = 1.0;
    }

    loadBuffers {|audioPath, server|
        var match = audioPath.standardizePath +/+ "*";
        var pairs = SoundFile.collect(match).collect {|sf, i|
            var key = sf.path.basename.splitext[0].asSymbol;
            var buf = Buffer.read(server, sf.path);

            [key, buf];
        };

        ^IdentityDictionary.newFrom(pairs.flat);
    }

    freeBuffers {
        buffers.do {|buffer|
            buffer.free;
        };
        buffers.clear();
    }

    hits {
        ^buffers.keys.asArray;
    }

    play {|key, mul=1, pan=0, out=0|
        var buffer, numChannels, synthdefName;

        if(buffers.includesKey(key).not) {
            "No buffer with this key".postln;
            ^nil;
        };

        buffer = buffers[key];
        numChannels = buffer.numChannels;
        synthdefName = this.class.synthdefs[numChannels - 1].name;

        Synth(synthdefName, [
            \buf, buffer,
            \mul, mul * vol,
            \pan, pan,
            \out, out
        ]);
    }

    randomHit {
        this.play(this.buffers.keys.choose);
    }

    path_ {|aPath|
        path = aPath;
        this.freeBuffers();
        buffers = this.loadBuffers(path, server);
    }

    buffers {
        ^buffers.shallowCopy;
    }
}

// Tasks:
// - print hits method
// - play a routine to a clock
// - use Tdefs

s.boot;
Drummer.addSynthDefs;
x = Drummer("Bob", "~/Projects/15-04_resonate/workshop/audio/drums/linndrum");
x.name = "Jim";
x.name_("Jim")
 .vol_(0.5);

x.hits.do {|hit|
    hit.postln;
};

x.play(\kick);
