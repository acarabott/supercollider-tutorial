/* ============================================================ */
/* Routines                                                     */
/* ============================================================ */

// Quick way
// ---------

{
    "hi".postln;
    2.wait;
    "bye".postln;
}.fork;


// Routines: under the hood
// ------------------------

r = Routine {
    "yo".postln;
    2.wait;
    "Mo".postln;
    4.wait;
    "Fo sho".postln;
};

r.play;
r.stop;
r.reset;

// If you want to stop and restart, easier to stop, recreate and play
// r.stop;r.reset; // same time will restart it
// r.yieldAndReset

~makeRoutine = {
    Routine {
        "yo".postln;
        2.wait;
        "Mo".postln;
        4.wait;
        "Fo sho".postln;
    };
};

r = ~makeRoutine.();
r.play;
r.stop; r = ~makeRoutine.(); r.play;




// Task
// -----
// Pausable, but...

t = Task {
    "one".postln;
    3.wait;
    "two".postln;
    10.wait;
    "three".postln;
};
t.play;
t.pause;
t.resume;


// No Condition
// ------------
c = Condition(false);
r = Routine {
    loop {
        1.wait;
        "yo".postln;
        c.wait;
    }
};

r.play;
c.test = true;
c.signal;
c.test = false;
r.stop;

// Unexpected results when quickly starting/stopping
// See helpfile for more info