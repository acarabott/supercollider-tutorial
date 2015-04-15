/* ============================================================ */
/* IO                                                           */
/* ============================================================ */

// running separate scd files
"~/Desktop/runme.scd".standardizePath.load;
"~/Desktop/runme.scd".standardizePath.loadPaths;


// running system commands
"ls ~".unixCmd;
~result = "ls ~".unixCmdGetStdOut;
~result = "ls ~".unixCmdGetStdOutLines;


// setting/getting environment variables
"PROJECT_PATH".setenv("~/myproject".standardizePath);
"echo $PROJECT_PATH".unixCmd;
"PROJECT_PATH".getenv;



// Reading/Writing files
// ----------------------

// Use File class for reading, writing, checking existence etc
f = File.open("~/Desktop/test.txt", "w");
f.write("this should be\nsomelines\n");
f.close;

// Archiving objects

[1, 2, 3, 4].writeArchive("~/Desktop/array".standardizePath);
x = Object.readArchive("~/Desktop/array".standardizePath);