; ====================================================================
; ----------------------------------------------------------------
; Structs
; ----------------------------------------------------------------

		struct 0
plyr_x		ds 2
plyr_y		ds 2
plyr_frame	ds 1
plyr_ani_timer	ds 1
plyr_ani_cntr 	ds 1
		finish

		struct RAM_Local
RAM_CurrTrack	ds 1
RAM_CurrSelect	ds 1
		finish

; ====================================================================
; ----------------------------------------------------------------
; Main
; ----------------------------------------------------------------

		di
		call	Video_InitPrint
	; Init settings
		xor	a
		ld	(RAM_CurrTrack),a
		ld	(RAM_CurrSelect),a
	; Load assets
		ld	hl,pal_FontNew
		ld	b,32
		ld	d,0
		call	Video_LoadPal
	; Print text
	if MERCURY
		ld	ix,str_TitlGG
		ld	bc,0102h
	else
		ld	ix,str_TitlMk
		ld	bc,0202h
	endif
		call	Video_Print
		call	.show_cursor
		call	.show_values
		ei
.loop:
; 		call	System_VSync
		call	System_Input
; 		call	Sound_Run

	; Right/Left
		ld	a,(Controller_1+on_press)
		ld	e,a
		ld	ix,RAM_CurrTrack
		bit	bitJoyRight,e
		jr	z,.n_right
		inc	(ix)
		call	.show_values
.n_right:
		bit	bitJoyLeft,e
		jr	z,.n_left
		ld	a,(ix)
		or	a
		jr	z,.n_left
		dec	(ix)
		call	.show_values
.n_left:

	; Down/Up
		ld	a,(Controller_1+on_press)
		ld	e,a
		ld	ix,RAM_CurrSelect
		bit	bitJoyDown,e
		jr	z,.n_down
		ld	a,(ix)
		cp	06h		; LIMIT
		jr	z,.n_down
; 		jp	nc,.n_down
		inc	(ix)
		call	.show_cursor
.n_down:
		bit	bitJoyUp,e
		jr	z,.n_up
		ld	a,(ix)
		or	a
		jr	z,.n_up
		dec	(ix)
		call	.show_cursor
.n_up:

		jp	.loop

; show values
.show_cursor:
		push	de
		push	ix
		ld	ix,str_Cursor
	if MERCURY
		ld	bc,0105h
	else
		ld	bc,0205h
	endif
		ld	a,(RAM_CurrSelect)
		add	a,c
		ld	c,a
		call	Video_Print
		pop	ix
		pop	de
		ret

; show values
.show_values:
		push	de
		push	ix
		ld	ix,RAM_CurrTrack
		ld	de,140h+30h
	if MERCURY
		ld	bc,0904h
	else
		ld	bc,0A04h
	endif
		call	.this_val
		pop	ix
		pop	de
		ret

; ====================================================================
; ----------------------------------------------------------------
; Subs
; ----------------------------------------------------------------

; ; hl - RAM_PlyrCurrIds
;
; .modify_id:
; 		ld	a,(hl)
; 		add 	a,d
; ; 		and	00000011b
; 		ld	(hl),a
; 		ret
; .modify_select:
; 		ld	a,(RAM_CurrSelect)
; 		add 	a,d
; 		and	00000001b			; limit
; 		ld	(RAM_CurrSelect),a
; 		ret
; .modify_track:
; 		ld	a,(RAM_CurrTrack)
; 		add 	a,d
; 		and	00000001b
; 		ld	(RAM_CurrTrack),a
; 		ret
;
; .play_track:
; 		ld	a,(hl)
; 		ld	de,0
; 		add 	a,a
; 		add 	a,a
; 		add	a,a
; 		add	a,a
; 		ld	e,a
; 		ld	hl,trackData_test
; 		add 	hl,de
; 		ld	b,(hl)
; 		inc 	hl
; 		ld	c,(hl)
; 		inc 	hl
; 		ld	d,(hl)
; 		inc 	hl
; 		ld	e,(hl)
; 		inc 	hl
; 		ld	a,(RAM_CurrTrack)
; 		call	Sound_SetTrack
;
; 		ld	de,0
; 		ld	a,(RAM_CurrTrack)
; 		ld	e,a
; 		ld	hl,RAM_PlyrCurrVol
; 		add 	hl,de
; 		ld	c,(hl)
; 		jp	Sound_SetVolume
;
; .stop_track:
; 		ld	a,(RAM_CurrTrack)
; 		jp	Sound_StopTrack

; ----------------------------------------
; show current value
.this_val:
		ld	hl,3800h
		in	a,(gg_info)
		and	1Fh
		jp	nz,.nocent
		ld	l,0CCh
.nocent:
		push	de
		ld	de,0
		ld	a,c		; Y pos left
		rrca	
		rrca
		and	07h
		ld	d,a
		ld	a,b		; X pos + Y pos right YYXXXXXXb
		and	1Fh
		add 	a,a
		ld	e,a
		ld	a,c
		and	11b
		rrca
		rrca
		or	e
		ld	e,a
		add 	hl,de
		pop	de

	; X/Y pos goes here
		ld	c,vdp_ctrl
		ld	a,h
		or	40h
		ld	h,a
		out	(c),l
		out	(c),h

		ld	c,vdp_data
		ld	hl,0
		ld	a,(ix)
		rrca
		rrca
		rrca
		rrca
		and	00001111b
		cp	0Ah
		jp	c,.no_A1
		add 	a,7
.no_A1:
		ld	l,a
		add 	hl,de
		out	(c),l
		out	(c),h

		ld	hl,0
		ld	a,(ix)
		and	00001111b
		cp	0Ah
		jp	c,.no_A2
		add 	a,7
.no_A2:
		ld	l,a
		add 	hl,de
		out	(c),l
		out	(c),h
		ret

; ====================================================================
; ----------------------------------------------------------------
; Small data
; ----------------------------------------------------------------

str_TitlMk:	db "GEMA/Nikona sound driver",0Ah
		db 0Ah
		db "TrackID",0Ah
		db 0Ah
		db "  gemaPlayTrack",0Ah
		db "  gemaStopTrack",0Ah
		db "  gemaStopAll",0Ah
		db "  ????",0Ah
		db "  ????",0Ah
		db "  ????",0Ah
		db "  ????",0
str_TitlGG:
		db "GEMA/Nikona driver",0Ah
		db 0Ah
		db "TrackID",0Ah
		db 0Ah
		db "  gemaPlayTrack",0Ah
		db "  gemaStopTrack",0Ah
		db "  gemaStopAll",0Ah
		db "  ????",0Ah
		db "  ????",0Ah
		db "  ????",0Ah
		db "  ????",0
str_Cursor:
		db " ",0Ah
		db ">",0Ah
		db " ",0

pal_FontNew:
		dw 0000h,0EEEh,0CCCh,0AAAh,0888h,0444h,000Eh,0008h
		dw 00EEh,0088h,00E0h,0080h,0E00h,0800h,0000h,0000h
		dw 0000h,00AEh,008Ch,006Ah,0048h,0024h,000Eh,0008h
		dw 00EEh,0088h,00E0h,0080h,0E00h,0800h,0000h,0000h
; trackData_test:
; 		db DataBank0>>14
; 		db 0
; 		db 0
; 		db 3
; 		dw MusicBlk_TestMe
; 		dw MusicPat_TestMe
; 		dw MusicIns_TestMe
; 		dw 0,0
; 		dw 0
;
; 		db DataBank0>>14
; 		db 0
; 		db 0
; 		db 2
; 		dw MusicBlk_Gigalo
; 		dw MusicPat_Gigalo
; 		dw MusicIns_Gigalo
; 		dw 0,0
; 		dw 0
;
; 		db DataBank0>>14
; 		db 0
; 		db 0
; 		db 3
; 		dw MusicBlk_TestMe
; 		dw MusicPat_TestMe
; 		dw MusicIns_TestMe
; 		dw 0,0
; 		dw 0
;
; 		db DataBank0>>14
; 		db 0
; 		db 0
; 		db 3
; 		dw MusicBlk_TestMe
; 		dw MusicPat_TestMe
; 		dw MusicIns_TestMe
; 		dw 0,0
; 		dw 0
