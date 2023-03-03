# GemaNikona
A sound driver for the Sega Genesis and Sega 32X running entirely on Z80

This is an entire rewrite of the Z80 sound driver that Marsiano-MARS used as that one was a rushed mess, this entire rewrite was better planned and more tested.

The entire sound driver: Z80 code, 68k calls and music/sfx data is located at the /sound folder. ** THE 32X SUPPORT IS CURRENTLY HARDCODED FOR THIS SOURCE CODE **

### Features
- 32X: 7 pseudo-PWMs with Stereo sampling at 22500hz
- Supports all 10 channels PSG+FM including it's special features.
- DAC samplerate at 16000hz
- ROM-protection for DMA, perserves samplerate quality
- FM3 special mode in GEMS style
- PSG supports effects Attack rate, Release rate...
- PSG Tone 3 autodetection
- Global sub-beats feature: to use speeds other than tempo 150/120
- Multiple tracks, currently using 2 slots: for music and sound effects.
- Tracks are in impulse-module style: patterns sorted by blocks order, you can play tracks by setting a starting block.
- Supports impulse's effects A,B,C*,X

### Current issues
- Some FM's might not get silenced if stopping multiple tracks (gemaStopAll)
