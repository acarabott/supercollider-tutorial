/* ============================================================ */
/* Sending OSC                                                  */
/* ============================================================ */


// Send OSC with instances of NetAddr
{begin nostudent}
n = NetAddr("127.0.0.1", NetAddr.langPort);
{end nostudent}

OSCdef(\narcissist, {|msg, time, addr, recvPort|
    "ain't I cute, ain't I clever".postln;
    [msg, time, addr, recvPort].postln;
}, '/narc', n);

// one argument
n.sendMsg("/narc", 1);

// multiple arguments
n.sendMsg("/narc", 1, 2, 3.5);

// arrays will be converted to Int8Array
n.sendMsg("/narc", 1, 2, 3, "sep", [4, 5, 6]);


// Timestamps
// ----------

// sent immediately, with a timestamp for time correction by receiver
n.sendBundle(10, ["/narc", 10]);

// Raw OSC
// -------
["/narc", 1, 2, 3].asRawOSC.postln;
n.sendRaw(["/narc", 1, 2, 3].asRawOSC);
