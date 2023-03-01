; ===========================================================================
; +-----------------------------------------------------------------+
; PUZZUL GENESIS
; +-----------------------------------------------------------------+

		include	"system/macros.asm"		; Assembler macros
		include	"system/shared.asm"		; Shared Genesis/32X variables
		include	"system/md/map.asm"		; Genesis hardware map
		include	"system/md/const.asm"		; Genesis variables
		include	"system/mars/map.asm"		; 32X hardware map
		include "code/global.asm"		; Global user variables on the Genesis
		include	"system/head_md.asm"		; 32X header

; ====================================================================
; ----------------------------------------------------------------
; Main
; ----------------------------------------------------------------

		jsr	(Sound_init).l
		jsr	(Video_init).l
		jsr	(System_Init).l
		move.w	#0,(RAM_Glbl_Scrn).w
		jmp	(Md_ReadModes).l

; ====================================================================
; --------------------------------------------------------
; TOP 68K code
; --------------------------------------------------------

		include	"system/md/sound.asm"
		include	"system/md/video.asm"
		include	"system/md/system.asm"
Md_ReadModes:
		moveq	#0,d0
		move.w	(RAM_Glbl_Scrn).w,d0
		and.w	#%0111,d0		; <-- current limit
		lsl.w	#2,d0
		move.l	.pick_boot(pc,d0.w),a0
		jsr	(a0)
		bra.s	Md_ReadModes
.pick_boot:
		dc.l RamCode_Scrn1
		dc.l RamCode_Scrn1
		dc.l RamCode_Scrn1
		dc.l RamCode_Scrn1
		dc.l RamCode_Scrn1
		dc.l RamCode_Scrn1
		dc.l RamCode_Scrn1
		dc.l RamCode_Scrn1
		align 2

; ====================================================================
; --------------------------------------------------------
; Screen modes
; --------------------------------------------------------

		align $100
RamCode_Scrn1:
		include "code/screen_1.asm"
; RamCode_Scrn2:
; 		include "code/screen_2.asm"

; ====================================================================
; --------------------------------------------------------
; Stuff stored on the 880000+ ROM area
; --------------------------------------------------------

		align 4
; 		phase $880000+*
Z80_CODE:	include "system/md/z_driver.asm"	; Called once
Z80_CODE_END:
; 		include "system/md/sub_dreq.asm"	; DREQ transfer only works on 880000
		include "sound/tracks.asm"		; GEMA: Track data
		include "sound/instr.asm"		; GEMA: FM instruments
		include "sound/smpl_dac.asm"		; GEMA: DAC samples
		dephase
		align 2

; ====================================================================
; ----------------------------------------------------------------
; 68K DATA BANK
; ----------------------------------------------------------------

MDBNK0_START:
		include "data/md_bank0.asm"	; <-- 68K ONLY bank data

; ====================================================================
; ----------------------------------------------------------------
; MD DMA data: Requires RV bit set to 1, BANK-free
; ----------------------------------------------------------------

		align $8000
		include "data/md_dma.asm"

; ====================================================================
; --------------------------------------------------------
; SH2's ROM view
; This section will be gone if RV bit is set to 1
; --------------------------------------------------------

; 		phase CS1+*
; 		align 4
; 		include "sound/smpl_pwm.asm"		; GEMA: PWM samples
; 		include "data/mars_rom.asm"
; 		dephase

; ====================================================================
; ---------------------------------------------
; End
; ---------------------------------------------

ROM_END:
		align $8000
