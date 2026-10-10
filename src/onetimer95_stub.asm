;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
;	onetimer95 segment stub. Retail $082BD0-$082FC1.
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; region code
	org	$82BD0

; includes for stubs to replace removed code
	include	stubinc\ports.inc	;IO_* / VDP_* ports
	include	stubinc\equals.inc	;VDP status bits
	include	ram95.asm		;RAM map

; External addresses outside $082BD0-$082FC1, read from lst/nhl95.bin.
setc1player = $AD80		;setup95_01
setc2player = $AD8A		;setup95_01
setc3player = $AD96		;setup95_01
setc4player = $ADA2		;setup95_01
vtoa = $7C586			;video95_03
Setplass = $81540		;checks95_02
assexit = $8155E		;checks95_02
Findhittype = $84A16		;input95_01
doshot = $84B6E			;input95_01
SetSPA = $8BC9A			;checks95_06

; Main segment code
	include	onetimer95.asm
