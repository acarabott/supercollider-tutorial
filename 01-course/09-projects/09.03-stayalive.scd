/* ============================================================ */
/* Stay Alive!                                                  */
/* ============================================================ */

// SkipJack runs a task in the background, and survives CmdPeriod
SkipJack({ "yo".postln;}, 1, name:"yo");
SkipJack.stop("yo");
SkipJack.stopAll;

~onBoot = {
    // load buffers, start synths etc
};

// Things to do before booting the server;
~serverSkipJackAction = {
    Server.default.options.outDevice = "Built-in Output";
    Server.default.options.hardwareBufferSize = "Built-in Input";
    Server.default.options.numOutputBusChannels = 10;
    Server.default.options.sampleRate = 44100;

    // start booting process
    Server.default.boot(onFailure: {});
    // set function to call once booted, quit sclang if it fails
    Server.default.doWhenBooted(~onBoot, onFailure: {1.exit});
};

// use a continuous countdown to check if we are still running
// if it gets to -2, quit supercollider

// Stay alive
~checkMax = 3;
~alive = ~checkMax;
~click = {
    ~alive = ~checkMax;
};

~langSkipJackAction = {
    "are we alive?".postln;
    if(~alive <= 0) {
        ~task.resume;
        ~task.play;
        (" "!10).join.post;
        "play".postln;
    };
    if(~alive <= -2) {
        1.exit;
    };
    ~alive = ~alive -1;
};

~task = Task {
    inf.do {
        "still alive".postln;
        ~click.value;
        2.wait;
    };
}.play;

SkipJack(~langSkipJackAction, ~checkMax - 1, name: "sclang");
SkipJack(~serverSkipJackAction, 10, name: "scsynth");
