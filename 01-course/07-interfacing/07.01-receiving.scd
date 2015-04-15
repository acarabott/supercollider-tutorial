/* ============================================================ */
/* Receiving OSC                                                */
/* ============================================================ */


// Opening UDP ports
// -----------------
// singleton instance of Main
thisProcess.openUDPPort(6666);
thisProcess.openPorts;
NetAddr.langPort;



// OSCdef
// ------
OSCdef(\testListener, {|msg, time, addr, recvPort|
    [msg, time, addr, recvPort].postln;
}, '/test');

// Disable
OSCdef(\testListener).disable;

// Introspection
AbstractResponderFunc.allFuncProxies;
AbstractResponderFunc.allEnabled;
AbstractResponderFunc.allDisabled;
OSCdef.all;

// Enable
OSCdef(\testListener).enable;

// Remove
OSCdef(\testListener).free;



// One shot
// --------
OSCdef(\mayfly, {
    "What a life....".postln;
}, '/test').oneShot;





// Restricting sources
// -------------------

// Restrict IP and port messages sent from
n = NetAddr("127.0.0.1", 6666);

OSCdef(\secret, {
    "what's the password?".postln;
}, '/test', n);

// what do we get? nothing!
// many programs (Processing, Max/MSP)
// send TO a fixed port
// send FROM a random one
// proof:

// dump all OSC (except scsynth notifications)
OSCdef.trace(true, true);

// Restart your processing app and watch the address: port change





// Restrict to just the IP address
// -------------------------------
n = NetAddr("127.0.0.1", nil)

OSCdef(\secret, {|msg, time, addr, recvPort|
    "what's the password?".postln;
}, '/test', n);

// Restrict to IP address and recvPort
// -----------------------------------
OSCdef(\secret, {|msg, time, addr, recvPort|
    "what's the password?".postln;
}, '/test', n, 6666);

// automatically opens port for us
thisProcess.openPorts;
