; ====================================================================
; --------------------------------------------------------
; GEMA/Nikona sound driver v0.5 MkIV/Mercury
; (C)2023 GenesisFan64
;
; Reads custom "miniature" ImpulseTracker files
; and automaticly picks the soundchip(s) to play.
;
; ⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣠⣴⣶⡿⠿⠿⠿⣶⣦⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀
; ⠀⠀⠀⠀⠀⠀⢀⣠⣶⢟⣿⠟⠁⢰⢋⣽⡆⠈⠙⣿⡿⣶⣄⡀⠀⠀⠀⠀⠀⠀
; ⠀⠀⠀⠀⣠⣴⠟⠋⢠⣾⠋⠀⣀⠘⠿⠿⠃⣀⠀⠈⣿⡄⠙⠻⣦⣄⠀⠀⠀⠀
; ⠀⢀⣴⡿⠋⠁⠀⢀⣼⠏⠺⠛⠛⠻⠂⠐⠟⠛⠛⠗⠘⣷⡀⠀⠈⠙⢿⣦⡀⠀
; ⣴⡟⢁⣀⣠⣤⡾⢿⡟⠀⠀⠀⠘⢷⠾⠷⡾⠃⠀⠀⠀⢻⡿⢷⣤⣄⣀⡈⢻⣦
; ⠙⠛⠛⠋⠉⠁⠀⢸⡇⠀⠀⢠⣄⠀⠀⠀⠀⣠⡄⠀⠀⢸⡇⠀⠈⠉⠙⠛⠛⠋
; ⠀⠀⠀⠀⠀⠀⠀⢸⡇⢾⣦⣀⣹⡧⠀⠀⢼⣏⣀⣴⡷⢸⡇⠀⠀⠀⠀⠀⠀⠀
; ⠀⠀⠀⠀⠀⠀⠀⠸⣧⡀⠈⠛⠛⠁⠀⠀⠈⠛⠛⠁⢀⣼⠇⠀⠀⠀⠀⠀⠀⠀
; ⠀⠀⠀⠀⠀⠀⠀⢀⣘⣿⣶⣤⣀⣀⣀⣀⣀⣀⣤⣶⣿⣃⠀⠀⠀⠀⠀⠀⠀⠀
; ⠀⠀⠀⠀⠀⣠⡶⠟⠋⢉⣀⣽⠿⠉⠉⠉⠹⢿⣍⣈⠉⠛⠷⣦⡀⠀⠀⠀⠀⠀
; ⠀⠀⠀⠀⢾⣯⣤⣴⡾⠟⠋⠁⠀⠀⠀⠀⠀⠀⠉⠛⠷⣶⣤⣬⣿⠀⠀⠀⠀⠀
; ⠀⠀⠀⠀⠀⠉⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠁⠀⠀⠀⠀⠀
; --------------------------------------------------------

; --------------------------------------------------------
; SETTINGS
; --------------------------------------------------------

; !! = leave as is unless you know what you are doing.
MAX_TRKCHN	equ 4		; !! Max Internal tracker channels: 4PSG (FM possible but not planned.)
; MAX_TRFRPZ	equ 8		; !! Max transferRom packets(bytes) (**AFFECTS WAVE QUALITY)
MAX_TBLSIZE	equ 4		; Max size for chip tables

; --------------------------------------------------------
; Structs
; --------------------------------------------------------

; trkBuff struct: 00h-30h
; unused bytes are free.
;
; trk_Status: %ERPx xxx0
; E - enabled
; R - Init|Restart track
; P - refill-on-playback
; 0 - Use global sub-beat
trk_status	equ 00h	; ** Track Status and flags (MUST BE at 00h)
trk_seqId	equ 01h ; ** Track ID to play.
trk_setBlk	equ 02h	; ** Start on this block
trk_tickSet	equ 03h	; ** Ticks for this track
trk_Blocks	equ 04h ; [W] Current track's blocks
trk_Patt	equ 06h ; [W] Current track's heads and patterns
trk_Instr	equ 08h ; [W] Current track's instruments
trk_Read	equ 0Ah	; [W] Track current pattern-read pos
trk_Rows	equ 0Ch	; [W] Track current row length
trk_cachHalf	equ 0Eh ; ROM-cache halfcheck
trk_cachInc	equ 0Fh ; ROM-cache increment
trk_rowPause	equ 10h	; Row-pause timer
trk_tickTmr	equ 11h	; Ticks timer
trk_currBlk	equ 12h	; Current block
trk_Panning	equ 13h ; Global panning for this track %LR000000
trk_Priority	equ 14h ; Priority level for this buffer
trk_LastBkIns	equ 15h
trk_LastBkBlk	equ 16h
trk_LastBkHdrs	equ 17h
trk_MaxChnls	equ 1Ch	; MAX avaialble channels
trk_MaxBlks	equ 1Dh ;     ----      blocks
trk_MaxHdrs	equ 1Eh ;     ----      headers
trk_MaxIns	equ 1Fh ;     ----      intruments
trk_RomCPatt	equ 20h ; [3b] ROM current pattern data to be cache'd
trk_RomPatt	equ 23h ; [3b] ROM TOP pattern data
trk_ChnList	equ 26h ; ** [W] Pointer to channel list for this buffer
trk_ChnCBlk	equ 28h ; ** [W] Pointer to block storage
trk_ChnCHead	equ 2Ah ; ** [W] Pointer to header storage
trk_ChnCIns	equ 2Ch	; ** [W] Pointer to intrument storage (ALWAYS used)
trk_ChnCach	equ 2Eh	; ** [W] Pointer to pattern storage

; chnBuff struct, 8 bytes ONLY
;
; chnl_Flags: LR00evin
; LR - Left/Right panning bits (REVERSE: 0-ON 1-OFF)
; e  - Effect*
; v  - Volume*
; i  - Intrument*
; n  - Note*
; * Gets cleared later.

chnl_Flags	equ 0	; Playback flags
chnl_Chip	equ 1	; Current Chip ID + priority for this channel
chnl_Note	equ 2
chnl_Ins	equ 3	; Starting from 01h
chnl_Vol	equ 4	; MAX to MIN: 40h-00h
chnl_EffId	equ 5
chnl_EffArg	equ 6
chnl_Type	equ 7	; Impulse-note update bits

; --------------------------------------------------------
; Variables
; --------------------------------------------------------

; PSG external control
; GEMS style.
COM		equ	0
LEV		equ	4
ATK		equ	8
DKY		equ	12
SLV		equ	16
RRT		equ	20
MODE		equ	24
DTL		equ	28
DTH		equ	32
ALV		equ	36
FLG		equ	40
TMR		equ	44
PVOL		equ	48
PARP		equ	52
PTMR		equ	56

; PWM control
PWCOM		equ	0
PWPTH_V		equ	8	; Volume | Pitch MSB (VVVVVVPPb)
PWPHL		equ	16	; Pitch LSB
PWOUTF		equ	24	; Output mode/bits | 32-bit address (%SlLRxiix) ii=$02 or $06
PWINSH		equ	32	; **
PWINSM		equ	40	; **
PWINSL		equ	48	; **

; --------------------------------------------------------
; RAM
; --------------------------------------------------------

		struct RAM_MsSound
trkBuff_0	ds 30h			; TRACK BUFFER 0
trkBuff_1	ds 30h			; TRACK BUFFER 1
trkBuff_2	ds 30h			; TRACK BUFFER 2
trkChnl_0	ds 8*MAX_TRKCHN
trkChnl_1	ds 8*MAX_TRKCHN
trkChnl_2	ds 8*MAX_TRKCHN
commZfifo	ds 40h		; Buffer for commands: 40h bytes
commZWrite	ds 1		; cmd fifo wptr (from 68k)
commZRomBlk	ds 1		; 68k ROM block flag
currTickBits	ds 1		; Current Tick/Subbeat flags (000000BTb B-beat, T-tick)
psgStereo	ds 1		; Game gear only: current and past values
tickSpSet	ds 1		; **
tickFlag	ds 1		; Tick flag from VBlank
tickCnt		ds 1		; ** Tick counter (PUT THIS AFTER tickFlag)
psgHatMode	ds 1		; Current PSGN mode
sizeof_mssnd	ds 1
		finish

; ============================================================
; --------------------------------------------------------
; Init Sound
; --------------------------------------------------------

Sound_Init:
		ld	a,09Fh
		out	(psg_ctrl),a			; Set PSG1 Volume to OFF
		ld	a,0BFh
		out	(psg_ctrl),a			; Set PSG2 Volume to OFF
		ld	a,0DFh
		out	(psg_ctrl),a			; Set PSG3 Volume to OFF
		ld	a,0FFh
		out	(psg_ctrl),a			; Set NOISE Volume to OFF
		ld	a,-1
		ld	(psgStereo),a
		ret

; ============================================================
; --------------------------------------------------------
; gemaTest
;
; For TESTING only.
; --------------------------------------------------------

gemaTest:
		ret
; 		bsr	sndReq_Enter
; 		move.w	#$00,d7		; Command $00
; 		bsr	sndReq_scmd
; 		bra 	sndReq_Exit

; --------------------------------------------------------
; gemaPlayTrack
;
; Play a track by number
;
; d0.b - Track number
; --------------------------------------------------------

gemaPlayTrack:
		ret
; 		bsr	sndReq_Enter
; 		move.w	#$01,d7		; Command $01
; 		bsr	sndReq_scmd
; 		move.b	d0,d7
; 		bsr	sndReq_sbyte
; 		bra 	sndReq_Exit

; --------------------------------------------------------
; gemaStopTrack
;
; Stops a track using that ID
;
; d0.b - Track number
; --------------------------------------------------------

gemaStopTrack:
		ret
; 		bsr	sndReq_Enter
; 		move.w	#$02,d7		; Command $02
; 		bsr	sndReq_scmd
; 		move.b	d0,d7
; 		bsr	sndReq_sbyte
; 		bra 	sndReq_Exit

; --------------------------------------------------------
; gemaStopAll
;
; Stop ALL tracks from ALL buffers.
;
; No arguments.
; --------------------------------------------------------

gemaStopAll:
		ret
; 		bsr	sndReq_Enter
; 		move.w	#$08,d7		; Command $08
; 		bsr	sndReq_scmd
; 		bra 	sndReq_Exit

; --------------------------------------------------------
; gemaSetBeats
;
; Sets global subbeats
;
; d0.w - sub-beats
; --------------------------------------------------------

gemaSetBeats:
		ret
; 		bsr	sndReq_Enter
; 		move.w	#$0C,d7		; Command $0C
; 		bsr	sndReq_scmd
; 		move.w	d0,d7
; 		bsr	sndReq_sword
; 		bra 	sndReq_Exit

; ============================================================
; --------------------------------------------------------
; Run sound driver
;
; Call this during VBlank ONLY
; --------------------------------------------------------

Sound_Run:
		ret

; 		;rst	8
; 		call	get_tick		; Check for Tick on VBlank
; 		;rst	20h			; Refill wave
; 		;rst	8
; 		ld	b,0			; b - Reset current flags (beat|tick)
; 		ld	a,(tickCnt)
; 		sub	1
; 		jr	c,.noticks
; 		ld	(tickCnt),a
; 		call	chip_env		; Process PSG and YM
; 		call	get_tick		; Check for another tick
; 		ld 	b,01b			; Set TICK (01b) flag, and clear BEAT
; .noticks:
; 		ld	a,(sbeatAcc+1)		; check beat counter (scaled by tempo)
; 		sub	1
; 		jr	c,.nobeats
; 		;rst	8
; 		ld	(sbeatAcc+1),a		; 1/24 beat passed.
; 		set	1,b			; Set BEAT (10b) flag
; .nobeats:
; 		;rst	8
; 		ld	a,b			; Any beat/tick change?
; 		or	a
; 		jr	z,.neither
; 		ld	(currTickBits),a	; Save BEAT/TICK bits
; 		;rst	8
; 		call	get_tick
; 		call	set_chips		; Send changes to sound chips
; 		call	get_tick
; 		;rst	8
; 		call	upd_track		; Update track data
; 		call	get_tick
; .neither:
; 		call	ex_comm			; External communication
; 		call	get_tick
; .next_cmd:
; 		ld	a,(commZWrite)		; Check command READ and WRITE indexes
; 		ld	b,a
; 		ld	a,(commZRead)
; 		cp	b
; 		jr	z,drv_loop		; If both are equal: no requests
; 		;rst	8
; 		call	.grab_arg
; 		cp	-1			; Got -1? (Start of command)
; 		jr	nz,drv_loop
; 		call	.grab_arg		; Read command number
; 		add	a,a			; * 2
; 		ld	hl,.list		; Then jump to one of these...
; 		;rst	8
; 		ld	d,0
; 		ld	e,a
; 		add	hl,de
; 		ld	a,(hl)
; 		inc	hl
; 		ld	h,(hl)
; 		;rst	8
; 		ld	l,a
; 		jp	(hl)
;
; ; --------------------------------------------------------
; ; Read cmd byte, auto re-rolls to 3Fh
; ; --------------------------------------------------------
;
; .grab_arg:
; 		push	de
; 		push	hl
; .getcbytel:
; 		ld	a,(commZWrite)
; 		ld	d,a
; 		rst	8
; 		ld	a,(commZRead)
; 		cp	d
; 		jr	z,.getcbytel	; wait until these counters change.
; 		rst	8
; 		ld	d,0
; 		ld	e,a
; 		ld	hl,commZfifo
; 		add	hl,de
; 		rst	8
; 		inc	a
; 		and	3Fh		; ** command list limit
; 		ld	(commZRead),a
; 		ld	a,(hl)		; a - the byte we got
; 		pop	hl
; 		pop	de
; 		ret
;
; ; --------------------------------------------------------
;
; .list:
; 		dw .cmnd_0		; 00h -
; 		dw .cmnd_1		; 01h - Play by track number
; 		dw .cmnd_2		; 02h - Stop by track number
; 		dw .cmnd_0		; 03h - Resume by track number
; 		dw .cmnd_0		; 04h -
; 		dw .cmnd_0		; 05h -
; 		dw .cmnd_0		; 06h -
; 		dw .cmnd_0		; 07h -
; 		dw .cmnd_8		; 08h - Stop ALL
; 		dw .cmnd_0		; 09h -
; 		dw .cmnd_0		; 0Ah -
; 		dw .cmnd_0		; 0Bh -
; 		dw .cmnd_C		; 0Ch - Set GLOBAL sub-beats
; 		dw .cmnd_0		; 0Dh -
; 		dw .cmnd_0		; 0Eh -
; 		dw .cmnd_0		; 0Fh -

; ; --------------------------------------------------------
; ; Command 00h
; ;
; ; Reserved for TESTING purposes.
; ; --------------------------------------------------------
;
; ; TEST COMMAND
;
; .cmnd_0:
; ; 		jp	.next_cmd
;
; ; 	if MARS
; ; 		ld	iy,pwmcom
; ; 		ld	hl,.tempset
; ; 		ld	de,8
; ; 		ld	b,e
; ; 		dec	b
; ; .copyme:
; ; 		ld	a,(hl)
; ; 		ld	(iy),a
; ; 		inc	hl
; ; 		add	iy,de
; ; 		djnz	.copyme
; ; 		ld	a,1
; ; 		ld	(marsUpd),a
; ; 		jp	.next_cmd
; ; .tempset:
; ; 		db 0001b
; ; 		db 01h
; ; 		db 00h
; ; 		db 11110000b|02h
; ; 		db (SmpIns_TEST>>16)&0FFh
; ; 		db (SmpIns_TEST>>8)&0FFh
; ; 		db (SmpIns_TEST)&0FFh
; ; 	else
; ; 		jp	.next_cmd
; ; 	endif
;
; 		call	dac_off
; 		ld	iy,wave_Start
; 		ld	hl,.tempset
; 		ld	b,0Bh
; .copyme:
; 		ld	a,(hl)
; 		ld	(iy),a
; 		inc	hl
; 		inc	iy
; 		djnz	.copyme
; 		ld	hl,100h
; 		ld	(wave_Pitch),hl
; 		ld	a,1
; 		ld	(wave_Flags),a
; 		call	dac_play
; 		jp	.next_cmd
; .tempset:
; 		dw TEST_WAVE&0FFFFh
; 		db TEST_WAVE>>16&0FFh
; 		dw (TEST_WAVE_E-TEST_WAVE)&0FFFFh
; 		db (TEST_WAVE_E-TEST_WAVE)>>16&0FFh
; 		dw 0
; 		db 0
; 		dw 0100h;+(ZSET_WTUNE)
;
; ; --------------------------------------------------------
; ; Command 01h:
; ;
; ; Make new track by sequence number
; ; --------------------------------------------------------
;
; .cmnd_1:
; 		call	.grab_arg	; d0: Sequence ID
; 		ld	c,a		; copy to c
; 		call	.srch_frid	; Search buffer with same ID or FREE to use.
; 		cp	-1
; 		jp	z,.next_cmd	; Return if failed.
; 		ld	(hl),0C0h	; Flags: Enable+Restart bits
; 		inc	hl
; 		ld	(hl),c		; ** write trk_seqId
; 		call	get_RomTrcks
; 		jp	.next_cmd
;
; ; --------------------------------------------------------
; ; Command 02h:
; ;
; ; Stop track by sequence number
; ; --------------------------------------------------------
;
; .cmnd_2:
; 		call	.grab_arg	; d0: Sequence ID
; 		ld	c,a		; copy to c
; 		call	.srch_frid
; 		cp	-1
; 		jp	z,.next_cmd
; 		ld	a,(hl)
; 		bit	7,a
; 		jp	z,.next_cmd
; 		ld	(hl),-1		; Flags | Enable+Restart bits
; 		inc	hl
; 		ld	(hl),-1		; Reset seqId
; 		rst	8
; 		jp	.next_cmd
;
; ; --------------------------------------------------------
; ; Command 08h:
; ;
; ; Stop ALL tracks
; ; --------------------------------------------------------
;
; .cmnd_8:
; 		ld	ix,nikona_BuffList
; .next_sall:
; 		ld	a,(ix)
; 		cp	-1
; 		jp	z,.next_cmd
; 		ld	h,(ix+1)
; 		ld	l,a
; 		ld	a,(hl)
; 		bit	7,a
; 		jr	z,.not_on
; 		ld	(hl),-1		; Flags | Enable+Restart bits
; 		inc	hl
; 		ld	(hl),-1		; Reset seqId
; .not_on:
; 		ld	de,10h
; 		add	ix,de
; 		jp	.next_sall
;
; ; --------------------------------------------------------
; ; Command 0Ch:
; ;
; ; Set global sub-beats
; ; --------------------------------------------------------
;
; .cmnd_C:
; 		call	.grab_arg	; d0.w: $00xx
; 		ld	c,a
; 		call	.grab_arg	; d0.w: $xx00
; 		ld	(sbeatPtck+1),a
; 		ld	a,c
; 		ld	(sbeatPtck),a
; 		jp	.next_cmd
;
; ; ------------------------------------------------
;
; .srch_frid:
; 		ld	ix,nikona_BuffList
; 		ld	de,10h
; .next:
; 		ld	a,(ix)
; 		cp	-1
; 		ret	z
; 		ld	h,(ix+1)
; 		ld	l,a
; 		add	ix,de
; 		inc	hl
; 		rst	8
; 		ld	a,(hl)		; ** a - trk_Id
; 		dec	hl
; 		cp	c
; 		jr	z,.found
; 		ld	a,(hl)		; ** a - trk_status
; 		or	a
; 		jp	m,.next
; .found:
; 		rst	8
; 		xor	a
; 		ret

; ====================================================================
; ----------------------------------------------------------------
; MASTER buffers list
;
; dw track_buffer
; dw channel_list,block_cache,header_cache,instr_cache,track_cache
; db 0,0,0,0
; ----------------------------------------------------------------

nikona_BuffList:
	dw trkBuff_0,trkChnl_0
	dw trkBuff_1,trkChnl_1
; 	dw trkBuff_2,trkChnl_2,trkBlks_2,trkHdrs_2,trkInsD_2,trkCach_2
; 	db MAX_BLOCKS,MAX_HEADS,MAX_INS,MAX_TRKCHN
	dw -1
;
; nikona_SetMstrList:
; 	db 0				; ** 32-bit 68k address **
; 	db (Gema_MasterList>>16)&0FFh
; 	db (Gema_MasterList>>8)&0FFh
; 	db Gema_MasterList&0FFh
