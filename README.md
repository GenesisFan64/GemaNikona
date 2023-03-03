# GemaNikona
A sound driver for the Sega Genesis and Sega 32X running entirely on Z80

This is an entire rewrite of the Z80 sound driver that Marsiano-MARS used as that one was a rushed mess, now this driver was better planned and carefully tested this time.

The entire sound driver: Z80 code, 68k calls and music/sfx data are located at the /sound folder. ** 32X SUPPORT IS CURRENTLY HARDCODED FOR THIS SOURCE CODE **

The sound testers are located on the /out folder: rom_md.bin for Genesis and rom_mars.bin for 32X

### Features
- 32X: 7 pseudo-PWMs with STEREO sampling at 22500hz
- Supports all 10 channels PSG+FM including their special features: PSG's Tone3, FM3 special and DAC playback
- DAC samplerate is at 16000hz
- FM3 special mode in GEMS style
- PSG supports effects Attack rate, Release rate...
- PSG Tone 3 autodetection
- ROM-protection for DMA, perserves DAC's sample quality
- Global sub-beats feature: to use speeds other than tempo 150/120
- Multiple tracks, currently using 2 slots: for music and sound effects.
- Tracks are in impulse-module style: patterns sorted by blocks order. You can play tracks by setting a starting block.
- Supports impulse's effects A,B,C*,X

### Current issues
- Some FM's might not get silenced if stopping multiple tracks (gemaStopAll)
