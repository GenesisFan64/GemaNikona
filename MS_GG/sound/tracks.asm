; ================================================================
; ------------------------------------------------------------
; DATA SECTION
;
; SOUND
; ------------------------------------------------------------

; ticks - %tttttttt
;   loc - pointer
;
; t-Ticks
; g-Use global tempo
gemaTrk macro ticks,loc
	db ticks
	db 0
	dw loc
	endm

; gemaHead
; block point, patt point, ins point
; numof_blocks,numof_patts,numof_ins
gemaHead macro blk,pat,ins
	dw blk
	dw pat
	dw ins
	endm

; Instrument macros
; do note that some 24-bit pointers add 90h to the MSB automaticly.
gInsNull macro
	db 00h,00h,00h,00h
	db 00h,00h,00h,00h
	endm

; alv: attack level
; atk: attack rate
; slv: sustain
; dky: decay rate (up)
; rrt: release rate (down)
; vib: (TODO)
gInsPsg	macro pitch,alv,atk,slv,dky,rrt,vib
	db 80h,pitch,alv,atk
	db slv,dky,rrt,vib
	endm

; same args as gInsPsg
; only one more argument for the noise type:
; mode: noise mode
;       %tmm
;        t  - Bass(0)|Noise(1)
;         mm- Clock(0)|Clock/2(1)|Clock/4(2)|Tone3(3)
;
gInsPsgN macro pitch,alv,atk,slv,dky,rrt,vib,mode
	db 90h|mode,pitch,alv,atk
	db slv,dky,rrt,vib
	endm

; ; 24-bit ROM pointer to FM patch data
; gInsFm macro pitch,fmins
; 	dc.b $A0,pitch,((fmins>>16)&$FF),((fmins>>8)&$FF)
; 	dc.b fmins&$FF,00h,00h,00h
; 	endm

; ; Same args as gInsFm, but the last 4 words of the data
; ; are the custom freqs for each operator in this order:
; ; OP1 OP2 OP3 OP4
; ;
; ; NOTE: pitch is useless here...
; gInsFm3	macro pitch,fmins
; 	dc.b $B0,pitch,((fmins>>16)&$FF),((fmins>>8)&$FF)
; 	dc.b fmins&$FF,00h,00h,00h
; 	endm
;
; ; start: Pointer to sample data:
; ;        dc.b end,end,end	; 24-bit LENGTH of the sample
; ;        dc.b loop,loop,loop	; 24-bit Loop point
; ;        dc.b (sound data)	; <-- Then the actual sound data
; ;
; ; flags: 00h - No Loop
; ; 	 $01 - Loop
; gInsDac	macro pitch,start,flags
; 	dc.b $C0|flags,pitch,((start>>16)&$FF),((start>>8)&$FF)
; 	dc.b start&$FF,0,0,0
; 	endm

; ; start: Pointer to sample data:
; ;        dc.b end,end,end	; 24-bit LENGTH of the sample
; ;        dc.b loop,loop,loop	; 24-bit Loop point
; ;        dc.b (data)		; Then the actual sound data
; ;
; ; flags: %00SL
; ;            L - Loop sample No/Yes
; ;           S  - Sample data is on STEREO
; gInsPwm	macro pitch,start,flags
;  if MARS
; 	dc.b $D0|flags,pitch,((start>>24)&$FF),((start>>16)&$FF)
; 	dc.b ((start>>8)&$FF),start&$FF,0,0
;  else
; 	dc.b 00h,00h,00h,00h
; 	dc.b 00h,00h,00h,00h
;  endif
; 	endm

; ------------------------------------------------------------

; 	align $8000

; ------------------------------------------------------------
; Nikona MAIN track-list
;
; ONLY the ticks can be set here.
; You can change the ticks mid-track using effect A
;
; Add $80 to the ticks value to use the GLOBAL
; sub-beats
;
; To set the sub-beats send the SetBeats command
; BEFORE playing your track:
; 	move.w	#new_beats,d0
; 	bsr	gemaSetBeats
; 	move.w	#track_id,d0
;	bsr	gemaPlayTrack
; ------------------------------------------------------------

Gema_MasterList:
	gemaTrk 3,GemaTrk_TEST_3	; Ticks, Track pointer (Default tempo: 150/120)
	gemaTrk 3,GemaTrk_TEST_4
	gemaTrk 3,GemaTrk_TEST_5
	gemaTrk 3,GemaTrk_TEST_0
	gemaTrk 3,GemaTrk_TEST_0
	gemaTrk 3,GemaTrk_TEST_0
	gemaTrk 3,GemaTrk_TEST_0
	gemaTrk 3,GemaTrk_TEST_3
	gemaTrk 3,GemaTrk_TEST_4
	gemaTrk 3,GemaTrk_TEST_5
	gemaTrk 3,GemaTrk_TEST_0
	gemaTrk 3,GemaTrk_TEST_0
	gemaTrk 3,GemaTrk_TEST_0
	gemaTrk 3,GemaTrk_TEST_0
	gemaTrk 3,GemaTrk_TEST_0
	gemaTrk 3,GemaTrk_TEST_0

	gemaTrk 3,GemaTrk_TEST_0
	gemaTrk 3,GemaTrk_TEST_0
	gemaTrk 3,GemaTrk_TEST_0
	gemaTrk 3,GemaTrk_TEST_0
	gemaTrk 3,GemaTrk_TEST_0
	gemaTrk 3,GemaTrk_TEST_0
	gemaTrk 3,GemaTrk_TEST_0
	gemaTrk 3,GemaTrk_TEST_0
	gemaTrk 3,GemaTrk_TEST_0
	gemaTrk 3,GemaTrk_TEST_0
	gemaTrk 3,GemaTrk_TEST_0
	gemaTrk 3,GemaTrk_TEST_0
	gemaTrk 3,GemaTrk_TEST_0
	gemaTrk 3,GemaTrk_TEST_0
	gemaTrk 3,GemaTrk_TEST_0
	gemaTrk 3,GemaTrk_TEST_0

; ------------------------------------------------------------
; BGM tracks
; ------------------------------------------------------------

GemaTrk_TEST_3:
	gemaHead .blk,.pat,.ins
.blk:
	binclude "sound/tracks/gigalo_blk.bin"
	align 2
.pat:
	binclude "sound/tracks/gigalo_patt.bin"
	align 2
.ins:
	gInsPsg 0,10h,04h,20h,06h,08h,00h
	gInsPsgN 0,00h,00h,00h,04h,20h,00h,100b
	gInsPsgN 0,00h,00h,00h,04h,20h,00h,101b
	gInsPsgN 0,00h,00h,00h,04h,40h,00h,110b

GemaTrk_TEST_4:
	gemaHead .blk,.pat,.ins
.blk:
	binclude "sound/tracks/temple_blk.bin"
	align 2
.pat:
	binclude "sound/tracks/temple_patt.bin"
	align 2
.ins:
	gInsPsg 0,00h,08h,20h,06h,03h,00h
	gInsPsg 0,00h,00h,30h,04h,04h,00h
	gInsPsgN 0,00h,30h,08h,10h,38h,01h,101b

GemaTrk_TEST_5:
	gemaHead .blk,.pat,.ins
.blk:
	binclude "sound/tracks/brinstr_blk.bin"
	align 2
.pat:
	binclude "sound/tracks/brinstr_patt.bin"
	align 2
.ins:
	gInsPsg 0,40h,08h,20h,01h,04h,00h
	gInsPsgN 0,10h,08h,20h,02h,01h,00h,011b

; ------------------------------------------------------------
; FIRST TRACK

GemaTrk_TEST_0:
	gemaHead .blk,.pat,.ins

; Max. 24 blocks
.blk:
	binclude "sound/tracks/test_blk.bin"
; Max. 24 patterns
.pat:
	binclude "sound/tracks/test_patt.bin"

; Max. 16 instruments
; Starting from 1.
.ins:
	gInsPsg 0,20h,20h,10h,00h,04h,0
	gInsPsgN +12,20h,20h,10h,00h,04h,0,011b
	gInsNull
	gInsNull
	gInsNull
	gInsNull
