;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
;	input95_03 segment stub. Retail $08B734-$08B9A7.
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; region code
	org	$8B734

; includes for stubs to replace removed code
	include	stubinc\ports.inc	;IO_* / VDP_* ports
	include	stubinc\equals.inc	;VDP status bits
	include	stubinc\ram_addrs.inc	;RAM names

; External addresses outside $08B734-$08B9A7, read from lst/nhl95.bin.
SPAlist = $5A34			;frames95
sroot = $7C512			;collide95_01
vtoa = $7C586			;video95_03
goaliesave = $80478		;checks95_01
rtss15 = $8B732			;checks95_05
doplayeracc = $8BCFA		;checks95_06

; Main segment code
	include	input95_03.asm
