	include	macros\genesis.mac	;String (main95.asm includes it in the full build)
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
;	video95 segment stub. Retail $079902-$07A7B3.
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; region code
	org	$79902

; includes for stubs to replace removed code
	include	stubinc\ports.inc	;IO_* / VDP_* ports
	include	stubinc\equals.inc	;VDP status bits
	include	ram95.asm		;RAM map

; External addresses outside $079902-$07A7B3, read from lst/nhl95.bin.
SoundCmd = $676D8		;sound95
sfx = $677AC		;sound95
find3d = $7C5EE		;middle95
Rinktilelist = $C4A7C		;Rink map (graphics95)
Sprites = $CA56A		;Sprite frames and tiles (graphics95)
Framermap = $14C148		;graphics95
Framermap2 = $14C308		;#. Second framer map, tiles at +8 (graphics95)
RevRinkTilelist = $16060E		;Reverse angle rink map (graphics95)

; Main segment code
	include	engine\video95.asm
