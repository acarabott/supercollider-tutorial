/* ============================================================ */
/* Other sequencing methods                                     */
/* ============================================================ */

// These are methods we don't have time to cover, but are worth checking out

// Patterns
// --------
// Patterns are a poweful, high level, language side approach to sequencing

Pattern.openHelpFile;
"PG_01_Introduction".openHelpFile;

(
Pbind(
    \freq, Prand([220, 330, 350, 440, 880], inf),
    \dur,  Prand([0.1, 0.3], inf)
).play;
)

// Demand Rate UGens
// -----------------
// Server side sequencing
// Sample accurate, but less flexible

(
{
    var trig, seq, freq;
    trig = Impulse.kr(MouseY.kr(1, 12));
    seq = Drand([Dseq((1..5).mirror1, 1), Drand((4..10), 8)], 2000);
    freq = Demand.kr(trig, 0, seq * 100);
    SinOsc.ar(freq + [0,0.7]).cubed.cubed.scaleneg(MouseX.kr(-1,1)) * 0.1;
}.play;
)

s.meter