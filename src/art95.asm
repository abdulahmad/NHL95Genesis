;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
;	art95: Graphics data and the credits.
;	The files of art\ in ROM order, included by nhl95.asm. No org: nhl95.asm sets org 0.
;	Each file has its own stub next to it (art\<file>_stub.asm) to build and verify it alone.
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

	include	art\graphics95.asm		; $0A1A5A  graphics: player pictures, rink, sprites, fonts, screen maps
	include	art\logopals95.asm		; $1A169A  team logo palettes
	include	art\arena95.asm		; $1A1A1A  ArenaGfxBank, the home team graphics
	include	art\credits95.asm		; $1A6C28  title screen credits text
