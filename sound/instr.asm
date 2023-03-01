; ====================================================================
; FM instrument patches
;
; This must be located at the 880000 area.
; 68K BANK 0 only
; ====================================================================

; Savestate FM data is located at: $2478
;
; Sizes:
; Normal FM ins: $20
; Special FM ins: $28
;
; FORMAT:
; dc.b $30,$34,$38,$3C
; dc.b $40,$44,$48,$4C
; dc.b $50,$54,$58,$5C
; dc.b $60,$64,$68,$6C
; dc.b $70,$74,$78,$7C
; dc.b $80,$84,$88,$8C
; dc.b $90,$94,$98,$9C
; db.b $B0,$B4,$22,$28
;
; $22 LFO: %0000evvv
; e - Enable
; v - Value
;
; $28 KEYS: %oooo0000
; o - Operators 4-1

; FM3 Special
FmIns_Sp_OpenHat:
		binclude "sound/instr/fm/fm3_openhat.gsx",$2478,$28
FmIns_Sp_ClosedHat:
		binclude "sound/instr/fm/fm3_closedhat.gsx",$2478,$28
; FmIns_Sp_Explosion:
; 		binclude "sound/instr/fm/fm3_sfx_boomworm.gsx",$2478,$28
FmIns_Sp_Cowbell:
		binclude "sound/instr/fm/fm3_cowbell.gsx",$2478,$28
; FmIns_Sp_Cork:
; 		binclude "sound/instr/fm/fm3_sfx_cork.gsx",$2478,$28
;
; FmIns3_Snare_Alien:
; 		binclude "sound/instr/fm/fm3_drumsnare_alien.gsx",$2478,$28
; FmIns3_Kick_Alien:
; 		binclude "sound/instr/fm/fm3_drumkick_alien.gsx",$2478,$28
;
FmIns_Bass_4:
		binclude "sound/instr/fm/bass_4.gsx",$2478,$20
FmIns_Bass_8:
		binclude "sound/instr/fm/bass_8.gsx",$2478,$20


FmIns_Synth_Plus:
		binclude "sound/instr/fm/OLD_synthplus.gsx",$2478,$20
FmIns_Bass_club:
		binclude "sound/instr/fm/OLD_bass_club.gsx",$2478,$20
FmIns_Bass_calm:
		binclude "sound/instr/fm/bass_calm.gsx",$2478,$20
FmIns_Trumpet_1:
		binclude "sound/instr/fm/OLD_trumpet_1.gsx",$2478,$20
FmIns_Trumpet_carnival:
		binclude "sound/instr/fm/OLD_trumpet_carnivl.gsx",$2478,$20
FmIns_brass_eur:
		binclude "sound/instr/fm/OLD_brass_eur.gsx",$2478,$20


; ====================================================================
; FM instrument patches
;
; This must be located at the 880000 area.
; 68K BANK 0 only
; ====================================================================

; Savestate FM data is located at: $2478
;
; Sizes:
; Normal FM ins: $20
; Special FM ins: $28

FmIns_Bass_Oil:
		binclude "sound/instr/fm/OLD/bass_oil.gsx",$2478,$20
FmIns_Organ_Ito:
		binclude "sound/instr/fm/OLD/organ_ito.gsx",$2478,$20
FmIns_Ding_Baseball:
		binclude "sound/instr/fm/OLD/ding_baseball.gsx",$2478,$20

; FmIns_Guitar_gem:
; 		binclude "sound/instr/fm/OLD/guitar_gem.gsx",$2478,$20
; Fmins_Guitar_Heavy:
; 		binclude "sound/instr/fm/OLD/guitar_heavy.gsx",$2478,$20
; Fmins_Guitar_puy:
; 		binclude "sound/instr/fm/OLD/guitar_puy.gsx",$2478,$20
; Fmins_Guitar_puy_2:
; 		binclude "sound/instr/fm/OLD/guitar_puy_2.gsx",$2478,$20
FmIns_DrumKick_gem:
		binclude "sound/instr/fm/OLD/drum_kick_gem.gsx",$2478,$20
;
; ; FmIns_DrumKick:
; ; 		binclude "sound/instr/fm/OLD/drum_kick.gsx",$2478,$20
; ; FmIns_DrumSnare:
; ; 		binclude "sound/instr/fm/OLD/drum_snare.gsx",$2478,$20
FmIns_ClosedHat:
		binclude "sound/instr/fm/OLD/hats_closed.gsx",$2478,$20
FmIns_PianoM1:
		binclude "sound/instr/fm/OLD/piano_m1.gsx",$2478,$20
; ; FmIns_PianoM116:
; ; 		binclude "sound/instr/fm/OLD/piano_m116.gsx",$2478,$20
;
; ; ;
; ; ; ; FmIns_Bass_gum:
; ; ; ; 		binclude "sound/instr/fm/OLD/bass_gum.gsx",$2478,$20
; FmIns_Bass_calm:
; 		binclude "sound/instr/fm/OLD/bass_calm.gsx",$2478,$20
; FmIns_Bass_heavy:
; 		binclude "sound/instr/fm/OLD/bass_heavy.gsx",$2478,$20
; FmIns_Bass_ambient:
; 		binclude "sound/instr/fm/OLD/bass_ambient.gsx",$2478,$20
; ; ; FmIns_Brass_gummy:
; ; ; 		binclude "sound/instr/fm/OLD/brass_gummy.gsx",$2478,$20
; FmIns_Flaute_1:
; 		binclude "sound/instr/fm/OLD/flaute_1.gsx",$2478,$20
FmIns_Bass_1:
		binclude "sound/instr/fm/OLD/bass_low.gsx",$2478,$20
FmIns_Bass_2:
		binclude "sound/instr/fm/OLD/bass_strong.gsx",$2478,$20
; FmIns_Bass_3:
; 		binclude "sound/instr/fm/OLD/bass_3.gsx",$2478,$20
; FmIns_Bass_4:
; 		binclude "sound/instr/fm/OLD/bass_4.gsx",$2478,$20
; FmIns_Bass_5:
; 		binclude "sound/instr/fm/OLD/bass_5.gsx",$2478,$20
; FmIns_Bass_club:
; 		binclude "sound/instr/fm/OLD/bass_club.gsx",$2478,$20
FmIns_Bass_donna:
		binclude "sound/instr/fm/OLD/bass_feellove.gsx",$2478,$20
FmIns_Bass_groove:
		binclude "sound/instr/fm/OLD/bass_groove.gsx",$2478,$20
FmIns_Bass_groove_2:
		binclude "sound/instr/fm/OLD/bass_groove_2.gsx",$2478,$20
FmIns_Bass_groove_gem:
		binclude "sound/instr/fm/OLD/bass_groove_gem.gsx",$2478,$20
FmIns_Bass_italo:
		binclude "sound/instr/fm/OLD/bass_italo.gsx",$2478,$20
FmIns_Bass_duck:
		binclude "sound/instr/fm/OLD/bass_duck.gsx",$2478,$20

; FmIns_Bass_kon:
; 		binclude "sound/instr/fm/OLD/bass_kon.gsx",$2478,$20

; FmIns_Bass_mecan:
; 		binclude "sound/instr/fm/OLD/bass_mecan.gsx",$2478,$20
;
; ; ; FmIns_Bass_heavy:
; ; ; 		binclude "sound/instr/fm/OLD/bass_heavy.gsx",$2478,$20
; ; ; FmIns_Bass_metal:
; ; ; 		binclude "sound/instr/fm/OLD/bass_metal.gsx",$2478,$20
; FmIns_Bass_synth:
; 		binclude "sound/instr/fm/OLD/bass_synth_1.gsx",$2478,$20
; FmIns_Guitar_1:
; 		binclude "sound/instr/fm/OLD/guitar_1.gsx",$2478,$20
; ; ; FmIns_Horn_1:
; ; ; 		binclude "sound/instr/fm/OLD/horn_1.gsx",$2478,$20
; FmIns_Organ_M1:
; 		binclude "sound/instr/fm/OLD/organ_m1.gsx",$2478,$20
; ; ; FmIns_Bass_Beach:
; ; ; 		binclude "sound/instr/fm/OLD/bass_beach.gsx",$2478,$20
; ; ; FmIns_Bass_Beach_2:
; ; ; 		binclude "sound/instr/fm/OLD/bass_beach_2.gsx",$2478,$20
; ; ; FmIns_Brass_Cave:
; ; ; 		binclude "sound/instr/fm/OLD/brass_cave.gsx",$2478,$20
; ; FmIns_Brass_Gem:
; ; 		binclude "sound/instr/fm/OLD/brass_gem.gsx",$2478,$20
; ; FmIns_Piano_Small:
; ; 		binclude "sound/instr/fm/OLD/piano_small.gsx",$2478,$20
FmIns_Piano_Aqua:
		binclude "sound/instr/fm/OLD/piano_aqua.gsx",$2478,$20

; FmIns_Trumpet_1:
; 		binclude "sound/instr/fm/OLD/trumpet_1.gsx",$2478,$20
FmIns_Trumpet_2:
		binclude "sound/instr/fm/OLD/trumpet_2.gsx",$2478,$20
; FmIns_Trumpet_kon:
; 		binclude "sound/instr/fm/OLD/trumpet_kon.gsx",$2478,$20
FmIns_Trumpet_puy:
		binclude "sound/instr/fm/OLD/trumpet_puy.gsx",$2478,$20
; FmIns_Trumpet_carnival:
; 		binclude "sound/instr/fm/OLD/trumpet_carnivl.gsx",$2478,$20

; FmIns_Bell_Glass:
; 		binclude "sound/instr/fm/OLD/bell_glass.gsx",$2478,$20
FmIns_Marimba:
		binclude "sound/instr/fm/OLD/marimba.gsx",$2478,$20

FmIns_Ambient_dark:
		binclude "sound/instr/fm/OLD/ambient_dark.gsx",$2478,$20
FmIns_Ambient_spook:
		binclude "sound/instr/fm/OLD/ambient_spook.gsx",$2478,$20
FmIns_Ambient_3:
		binclude "sound/instr/fm/OLD/ambient_3.gsx",$2478,$20
FmIns_Ding_toy:
		binclude "sound/instr/fm/OLD/ding_toy.gsx",$2478,$20
; FmIns_Bell_China:
; 		binclude "sound/instr/fm/OLD/bell_china.gsx",$2478,$20
; FmIns_Brass_Eur:
; 		binclude "sound/instr/fm/OLD/brass_eur.gsx",$2478,$20
FmIns_Brass_Puy:
		binclude "sound/instr/fm/OLD/brass_puy.gsx",$2478,$20
FmIns_Flaute_cave:
		binclude "sound/instr/fm/OLD/flaute_sea.gsx",$2478,$20
FmIns_Banjo_puy:
		binclude "sound/instr/fm/OLD/banjo_puy.gsx",$2478,$20
; FmIns_Violin_gem:
; 		binclude "sound/instr/fm/OLD/violin_gem.gsx",$2478,$20

FmIns_PSynth_plus:
		binclude "sound/instr/fm/OLD/psynth_plus.gsx",$2478,$20
FmIns_Ding_1:
		binclude "sound/instr/fm/OLD/ding_gem.gsx",$2478,$20
FmIns_Trombone_gem:
		binclude "sound/instr/fm/OLD/trombone_gem.gsx",$2478,$20

FmIns_HBeat_tom:
		binclude "sound/instr/fm/OLD/nadia_tom.gsx",$2478,$20

