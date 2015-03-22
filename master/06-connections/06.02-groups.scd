/* ============================================================ */
/* Groups                                                       */
/* ============================================================ */

// Exists on the server, a collection of nodes (synths, other groups)
// Represented client side with Group

(
// Useful SynthDefs
SynthDef(\tick, { |rate=1, out=0|
    Out.ar(out,
        Impulse.ar(rate)
    );
}).add;

SynthDef(\freeverb, { |in=0, room=0.9 out=0|
    Out.ar(out,
        FreeVerb.ar(In.ar(in), 0.5, room);
    );
}).add;

SynthDef(\comb, { |in=0, del=0.1, out=0|
    Out.ar(out,
        CombC.ar(In.ar(in), 0.4, del);
    );
}).add;
)

// Creating Groups
{begin nostudent}
~sigs = Group(s);
~tick = Synth.head(~sigs, \tick);


~fx = Group(~sigs, \addAfter);
~verbBus = Bus.audio(s, 1);
~verb = Synth.tail(~fx, \freeverb, [\in, ~verbBus]);
~tick.set(\out, ~verbBus);


~tock = Synth(\tick, [\rate, 1.5, \out, ~verbBus], ~sigs);
~verb.set(\room, 0.2);

~combBus = Bus.audio(s, 1);
~comb = Synth.head(~fx, \comb, [\in, ~combBus, \out, ~verbBus]);

// Set multiple group member parameters with same name
~sigs.set(\out, ~combBus);
~comb.set(\del, 0.01);
~verb.set(\room, 0.8);
{end nostudent}