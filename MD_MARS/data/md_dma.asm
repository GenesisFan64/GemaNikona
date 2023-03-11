; ====================================================================
; ----------------------------------------------------------------
; DMA ROM-DATA Transfer section
; 
; RV bit must be enabled to read from here
; ----------------------------------------------------------------

		align $8000
ASCII_FONT:	binclude "system/md/data/font.bin"
ASCII_FONT_e:
; Art_MenuFont:
; 		binclude "data/title/menu_art.bin"
; Art_MenuFont_e:
; 		align 2

		align $8000
; Art_Title_FG:
; 		binclude "data/title/title_art.bin"
; Art_Title_FG_e:
; 		align 2
Art_Title_BG:
		binclude "data/title/bg_art.bin"
Art_Title_BG_e:
		align 2



