;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
;	display95_02 segment stub. Retail $079D80-$07A029.
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; region code
	org	$79D80

; includes for stubs to replace removed code
	include	stubinc\ports.inc	;IO_* / VDP_* ports
	include	stubinc\equals.inc	;VDP status bits
	include	ram95.asm		;RAM map

; External addresses outside $079D80-$07A029, read from lst/nhl95.bin.
find3d = $7C5EE			;video95_03
rtss2 = $79CC8			;An rts (video95_01)
Sprites = $CA56A		;Sprite frames and tiles (graphics95_01)
Rinktilelist = $C4A7C		;Rink map (graphics95_01)
RevRinkTilelist = $16060E	;Reverse angle rink map (graphics95_01)

; Main segment code
	include	display95_02.asm
