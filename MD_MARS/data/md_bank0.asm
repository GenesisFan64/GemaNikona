; ====================================================================
; ----------------------------------------------------------------
; BANK 0 of 68k data ($900000-$9FFFFF)
; for big stuff like maps, levels, etc.
;
; For graphics use DMA and place your files at
; md_dma.asm (Watch out for the $20000 limit.)
;
; Maximum size: $0FFFFF bytes per bank
; ----------------------------------------------------------------

		include "data/m_palettes.asm"	; All 32X palettes will be here.

; ----------------------------------------------------------------
