/* ============================================================ */
/* Routines                                                     */
/* ============================================================ */

// Quick way
// ---------

{begin nostudent}
{
    "hi".postln;
    2.wait;
    "bye".postln;
}.fork;
{end nostudent}


// Routines: under the hood
// ------------------------

{begin nostudent}
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
{end nostudent}




// Task
// -----
// Pausable, but...

{begin nostudent}
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
{end nostudent}


// No Condition
// ------------
{begin nostudent}
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
{end nostudent}

// Unexpected results when quickly starting/stopping
// See helpfile for more info