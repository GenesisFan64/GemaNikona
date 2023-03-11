; ===========================================================================
; +-----------------------------------------------------------------+
; GAME TEMPLATE
; +-----------------------------------------------------------------+

		include "system/macros.asm"	; Assembler macros
		include "system/const.asm"	; Variables and constants
		include "system/map.asm"	; Memory map
		include "code/global.asm"	; Global variables and RAM

; ====================================================================
; DEFAULT BANK 0
; 0000-3FFFh
; 
; (0000-0400h is unaffected)
; ====================================================================

		di				; Disable interrupts
		im	1			; Interrput mode 1 (standard)
		jp	MS_Init			; Go to MS_Init

; ====================================================================
; ----------------------------------------------------------------
; RST routines will go here (starting at 0008h)
; 
; aligned by 8
; ----------------------------------------------------------------

		align 8

; ====================================================================
; ----------------------------------------------------------------
; VBlank and HBlank
; 
; located at 38h
; ----------------------------------------------------------------

		align 38h
		di
		push	af
		in	a,(vdp_ctrl)
		rlca
		jp	c,.vint
		or	80h
		jp	nz,.vint
		jp	(RAM_MkHint)
.vint:
		jp	(RAM_MkVint)

; ====================================================================
; ----------------------------------------------------------------
; Master System PAUSE Button interrupt
; 
; at address 0066h
; ----------------------------------------------------------------

		align 66h
		jp	(RAM_MkVint)

; ====================================================================
; ----------------------------------------------------------------
; System functions
; ----------------------------------------------------------------

		include "sound/gema_gg.asm"	; Sound driver
		include "system/video.asm"	; Video
		include "system/setup.asm"	; System

; ====================================================================
; ----------------------------------------------------------------
; MS Start
; ----------------------------------------------------------------

		align 400h
MS_Init:
		ld	sp,0DFF0h		; Stacks starts at 0DFF0h, goes backwards
		call	System_Init		; Init System
		call	Sound_Init		; Init Sound
		call	Video_Init		; Init Video

; ================================================================
; ------------------------------------------------------------
; Your code starts here
; ------------------------------------------------------------

		align 400h
CodeBank0:
		include	"code/main.asm"
		include	"data/bank_0.asm"
CodeBank0_e:
	if MOMPASS=1
		message "BANK 0: \{CodeBank0}-\{CodeBank0_e}"
	endif
	
; ====================================================================
; DEFAULT BANK 1
; 4000-7FFFh
; ====================================================================
		
		align 4000h
DataBank0:
		include	"sound/tracks.asm"

DataBank0_e:
; *** Header at the end of BANK 1
		align 7FF0h			; Align up to 7FF0h (almost at the end of BANK 1)
		db "TMR SEGA  "			; TMR SEGA
		dw 0				; Checksum *externally calculated*
		dw 0				; Serial
		db 0				; Version
		db 4Ch				; ROM size: 32k

	if MOMPASS=1
		message "This DATA bank: \{DataBank0}-\{DataBank0_e}"
	endif

; ====================================================================
		
ROM_END:	align 8000h
