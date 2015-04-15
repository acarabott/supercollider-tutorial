# Resonate SuperCollider Workshop

## Extra Session
- Concat
- setting up a project

## Day structure

- 10:00 - 10:15 - Setup, questions (15m)
- 10:15 - 11:45 - Session 1 (1h 30m)
- 11:45 - 12:00 - Break (15m)
- 12:00 - 13:00 - Session 2 (1h)
- 13:00 - 14:00 - Lunch (1h)
- 14:00 - 15:30 - Session 3 (1h 30m)
- 15:30 - 15:45 - Break (15m)
- 15:45 - 17:15 - Sesssion 4 (1h 30m)
- 17:15 - 18:00 - Questions / recap / experimenting (45m)

## Day 1

### Session 1 - Basics

- Setup / IDE basics
    - Help System
- Printing
    - Last thing posted
- Make sounds, servertools, global vars, interpreter
- Comments
- Precedence

- Controlling sounds
    - args/vars
    - MIDI In
    - ar / kr
- Recording from the server

### Sessions 2 & 3 - SynthDefs, Synthesis Basics

- Filters
- Envelopes
- Polyphony
- Generators
- Combining sounds
- Multichannel expansion
- Modulation
- mul - add
- examples

### Session 4 - Audio Files

- Buffers
- Playing
    - PlayBuf / BufRd / LoopBuf
- Recording, SoundIn








## Day 2

### Session 1 & 2 - Sequencing

+ Routines
+ Forks, Subroutines
+ Clocks
+ Patterns
+ Tdefs

### Session 3 - sclang

+ Language vs Server
    + GPU / CPU analogy
    + Impulse/SendReply vs poll/get
+ Language basics
    + conditionals
+ collections
    + Load a lot of buffers
+ Functions
    + Calling functions
    + Named params
+ Order of operations
+ Defs
+ Loops / Collect / Select / Reject
+ mapping values (linlin etc)
+ Symbols
+ Classes
    + New
    + Getter/Setter syntax, chaining
+ Where to look for language help

### Session 4 - Connecting Nodes
+ Ordering
+ Groups
+ FX


## Day 3

### Session 1 - Machine Listening pt.1

+ Amplitude
+ Onsets
+ Beattrack
+ Pitch/Tartini

### Session 2 - Interfacing pt.1

+ Receiving OSC
    + Opening ports to receive on
    + OSCdef
Task: Add sounds and sequences of sounds to incoming osc messages

### Session 2 - Machine Listening pt.2
+ FFT / IFFT
    + Buffer wintype
    + FFTSubbandPower
+ MFCC

### Session 3 - Interfacing pt.2

+ Sending OSC
- Sending info to Processing app
+ Sending MIDI

### Session 4 - Project Time / Buffer session

#### Further Synthesis
- Granular
- Phase Vocoder
- Examples - Steal This Sound
- Concatenative

#### GUI
- Sliders
    + Multisliders
    + EZSlider
    + 2D Slider
- Buttons
- Meter View