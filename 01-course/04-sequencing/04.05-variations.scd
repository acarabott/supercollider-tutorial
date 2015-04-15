/* ============================================================ */
/* Variations                                                   */
/* ============================================================ */

t = TempoClock();
t.tempo = 1;


// Basic Routine
// --------------
Tdef(\hats, {
    inf.do {|i|
        Synth(\hat);
        0.25.wait;
    }
}).play(t, quant:1);


// Fixed Variation
// ---------------

Tdef(\hats, {
    var muls = [1, 0.4, 0.3, 0.2];
    inf.do {|i|
        Synth(\hat, [\mul, muls.wrapAt(i)]);
        0.25.wait;
    }
}).play(t, quant:1);

// Random Variation
// ----------------
Tdef(\hats, {
    inf.do {|i|
        Synth(\hat, [\mul, 1.0.rand]);
        0.125.wait;
    }
}).play(t, quant:1);

// Chance
// ------

Tdef(\hats, {
    inf.do {|i|
        if(0.75.coin) {
            Synth(\hat, [\mul, 1.0.rand]);
        };
        0.125.wait;
    }
}).play(t, quant:1);

// Doubling, sub-routines
// ----------------------
Tdef(\hats, {
    var dur = 0.25;
    inf.do {|i|
        Synth(\hat, [\mul, 1.0.rand]);
        if(0.5.coin) {
            {
                (dur * 0.5).wait;
                Synth(\hat, [\mul, 1.0.rand]);
            }.fork(t);
        };
        dur.wait;
    }
}).play(t, quant:1);


// Probablistic Drum Machine
// -------------------------
Tdef(\kick, {
    var dur = 0.25;
    var pattern = [1, 0.25, 0, 0];
    // var pattern = [1, 0.25, 0, 0,    1, 0, 0, 0.5];
    inf.do {|i|
        // Expressed slightly differently
        pattern.do {|chance|
            if(chance.coin) {
                Synth(\kick);
            };
            dur.wait;
        };
    };
}).play(t, quant:1);


Tdef(\snare, {
    // can not have this, but use Quant offset
    1.wait;
    inf.do {|i|
        var times = (rrand(1, 8));
        // var times = [1, 2, 4, 8].choose;
        // var times = [1, 2, 4, 8].wchoose([0.5, 0.1, 0.2, 0.2]);
        // var times = [1, 2, 4, 8].wchoose([5, 1, 2, 2].normalizeSum);
        var dur = 0.5 / times;
        {
            times.do {|j|
                Synth(\snare);
                dur.wait;
            };
        }.fork(t);
        1.wait;
    };
}).play(t, quant:4);
// }).play(t, quant:Quant(4));
