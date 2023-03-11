; ====================================================================
; ----------------------------------------------------------------
; Settings
; ----------------------------------------------------------------

MSRAM_START	equ	0C000h		; MS RAM Start
MAX_MSERAM	equ	1000h		; Maximum temporal RAM for screen modes
MAX_PRNTLIST	equ	16		; Max print values

varNullVram	equ	1FFh

; ====================================================================
; ----------------------------------------------------------------
; Variables
; ----------------------------------------------------------------

; --------------------------------------------------------
; System
; --------------------------------------------------------

; ------------------------------------------------
; Controller buttons
; ------------------------------------------------

bitJoyStart	equ 7
bitJoy1		equ 4
bitJoy2		equ 5
bitJoyRight	equ 3
bitJoyLeft	equ 2
bitJoyDown	equ 1
bitJoyUp	equ 0

JoyUp		equ 01h
JoyDown 	equ 02h
JoyLeft		equ 04h
JoyRight	equ 08h
Joy1		equ 10h
Joy2		equ 20h

; ====================================================================
; ----------------------------------------------------------------
; Alias
; ----------------------------------------------------------------

Controller_1	equ RAM_InputData
Controller_2	equ RAM_InputData+sizeof_input

VDP_PALETTE	equ 0C000h				; Palette

; ====================================================================
; ----------------------------------------------------------------
; Structures
; ----------------------------------------------------------------

; Controller
		struct 0
on_hold		ds 1
on_press	ds 1
sizeof_input	ds 1
		finish

; ====================================================================
; ----------------------------------------------------------------
; Master System RAM
;
; Note: 0DFFCh-0DFFFh (0FFFCh-0FFFFh)
; is reserved for bankswitch
; ----------------------------------------------------------------

; This looks bad but it works as intended

	; First pass, empty sizes
		struct MSRAM_START		; Set struct at start of our base RAM
	if MOMPASS=1
RAM_MsSound	ds 1
RAM_MsVideo	ds 1
RAM_MsSystem	ds 1
RAM_Local	ds 1
RAM_Global	ds 1
sizeof_mdram	ds 1
	else
	
	; Second pass, sizes are set
RAM_MsSound	ds sizeof_mssnd-RAM_MsSound
RAM_MsVideo	ds sizeof_msvid-RAM_MsVideo
RAM_MsSystem	ds sizeof_mssys-RAM_MsSystem
RAM_Local	ds MAX_MSERAM
RAM_Global	ds sizeof_global-RAM_Global
sizeof_msram	ds 1
	endif					; end this section
	
	; --------------------------------
	; Report RAM usage
	; on pass 7
	if MOMPASS=5
		message "MS RAM ends at: \{sizeof_msram}"
	endif
		finish

; ====================================================================
; ----------------------------------------------------------------
; Video cache RAM
; ----------------------------------------------------------------

		struct RAM_MsVideo
RAM_VidPrntList	ds MAX_PRNTLIST*3		; VDP address (WORD), type (BYTE)
RAM_VidPrntVram	ds 2				; Current VRAM address for the Print routines
RAM_VdpCache	ds 11
RAM_SprtY	ds 64				; Y list
RAM_SprtX	ds 64*2				; X list + char
RAM_CurrSprY	ds 2
RAM_CurrSprX	ds 2
sizeof_msvid	ds 1
		finish

