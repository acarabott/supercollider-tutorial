/* ============================================================ */
/* Receiving OSC                                                */
/* ============================================================ */


// Opening UDP ports
// -----------------
{begin nostudent}
// singleton instance of Main
thisProcess.openUDPPort(6666);
thisProcess.openPorts;
NetAddr.langPort;
{end nostudent}



// OSCdef
// ------
{begin nostudent}
OSCdef(\testListener, {|msg, time, addr, recvPort|
    [msg, time, addr, recvPort].postln;
}, '/test');
{end nostudent}

// Disable
{begin nostudent}
OSCdef(\testListener).disable;
{end nostudent}

// Introspection
AbstractResponderFunc.allFuncProxies;
AbstractResponderFunc.allEnabled;
AbstractResponderFunc.allDisabled;
OSCdef.all;

// Enable
{begin nostudent}
OSCdef(\testListener).enable;
{end nostudent}

// Remove
{begin nostudent}
OSCdef(\testListener).free;
{end nostudent}



// One shot
// --------
{begin nostudent}
OSCdef(\mayfly, {
    "What a life....".postln;
}, '/test').oneShot;
{end nostudent}





// Restricting sources
// -------------------

// Restrict IP and port messages sent from
{begin nostudent}
n = NetAddr("127.0.0.1", 6666);

OSCdef(\secret, {
    "what's the password?".postln;
}, '/test', n);
{end nostudent}

// what do we get? nothing!
// many programs (Processing, Max/MSP)
// send TO a fixed port
// send FROM a random one
// proof:

// dump all OSC (except scsynth notifications)
{begin nostudent}
OSCdef.trace(true, true);
{end nostudent}

{begin nostudent}
// Restart your processing app and watch the address: port change
{end nostudent}





// Restrict to just the IP address
// -------------------------------
{begin nostudent}
n = NetAddr("127.0.0.1", nil)

OSCdef(\secret, {|msg, time, addr, recvPort|
    "what's the password?".postln;
}, '/test', n);
{end nostudent}

// Restrict to IP address and recvPort
// -----------------------------------
{begin nostudent}
OSCdef(\secret, {|msg, time, addr, recvPort|
    "what's the password?".postln;
}, '/test', n, 6666);

// automatically opens port for us
thisProcess.openPorts;
{end nostudent}