;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
;	video95_01 segment stub. Retail $079902-$07A761.
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; region code
	org	$79902

; includes for stubs to replace removed code
	include	stubinc\ports.inc	;IO_* / VDP_* ports
	include	stubinc\equals.inc	;VDP status bits
	include	ram95.asm		;RAM map

; External addresses outside $079902-$07A761:
find3d = $7C5EE			;video95_02
Sprites = $CA56A		;Sprite frames and tiles (graphics95_01)
Rinktilelist = $C4A7C		;Rink map (graphics95_01)
RevRinkTilelist = $16060E	;Reverse angle rink map (graphics95_01)
SoundCmd = $676D8		;sound95_01
sfx = $677AC			;sound95_01
Framermap = $14C148		;#. Framer map, tiles at +8 (graphics95_01)
Framermap2 = $14C308		;#. Second framer map, tiles at +8 (graphics95_01)

; Main segment code
	include	video95_01.asm
