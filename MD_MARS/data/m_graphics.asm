; ====================================================================
; ----------------------------------------------------------------
; Put your 32X graphics here, indexed or direct
;
; These are located on the SH2's ROM area, this will be gone
; if RV is set to 1
;
; Labels MUST be aligned by 4
; ----------------------------------------------------------------

		align 4
MarsGfx_TEMP:
		binclude "data/title/mars/bg_mars_art.bin"
		align 4
Textr_pecsi:
		binclude "data/title/mars/mtrl/mikami_art.bin"
		align 4
