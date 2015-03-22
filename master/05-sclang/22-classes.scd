/* ============================================================ */
/* Classes                                                      */
/* ============================================================ */

{begin nostudent}
Drummer : Object {
    classvar < synthdefs;

    var <> name;
    var <  path;
    var <  buffers;
    var <  server;
    var <> vol;

    *initClass {
        this.createSynthDefs();
    }

    *createSynthDefs {
        synthdefs = [1, 2].collect {|nc|
            var name = ("drummer-" ++ nc).asSymbol;
            SynthDef(name, { |buf=0, mul=1, pan=0, out=0|
                Out.ar(out,
                    PlayBuf.ar(nc, buf, BufRateScale.kr(buf), doneAction: 2);
                );
            });
        };
    }

    *addSynthDefs {
        this.synthdefs.do {|synthdef|
            synthdef.add;
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
        vol = 1;

        buffers = IdentityDictionary[];
        this.loadBuffers(path);
    }

    freeBuffers {
        buffers.do {|buffer|
            buffer.free;
        };
        buffers.clear();
    }

    loadBuffers {|audioPath|
        var match = audioPath.standardizePath +/+ "*";
        var pairs = SoundFile.collect(match).collect {|sf, i|
            var key = sf.path.basename.splitext[0].asSymbol;
            var buf = Buffer.read(server, sf.path);

            [key, buf];
        };
        buffers = IdentityDictionary.newFrom(pairs.flat);
    }

    path_ {|aPath|
        path = aPath;
        this.freeBuffers();
        this.loadBuffers(path);
    }

    hits {
        ^buffers.keys;
    }

    play {|key, mul=1, pan=0, out=0|
        var buffer, nc, synthdef;

        if(buffers.includesKey(key).not) {
            ^nil;
        };

        buffer = buffers[key];
        nc = buffer.numChannels;
        synthdef = this.class.synthdefs[nc - 1].name;

        Synth(synthdef, [\buf, buffer, \mul, mul * vol, \pan, pan, \out, out]);
    }

    // Task: Implement this
    random {
        this.play(x.buffers.keys.choose);
    }

    // Tasks:
    // - print hits method
    // - play a routine to a clock
    // - use Tdefs
}


s.boot;
Drummer.addSynthDefs;
x = Drummer("Bob", "~/Projects/15-04_resonate/workshop/audio/linndrum");
x.name = "Jim";
x.name_("Jim")
 .vol_(0.5);

x.hits.do {|hit|
    hit.postln;
};

x.play(\kick);
{end nostudent}