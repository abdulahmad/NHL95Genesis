;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
;	replay95 segment stub. Retail $08D39A-$08DF59.
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; region code
	org	$8D39A

; includes for stubs to replace removed code
	include	stubinc\ports.inc	;IO_* / VDP_* ports
	include	stubinc\equals.inc	;VDP status bits
	include	ram95.asm		;RAM map

; External addresses outside $08D39A-$08DF59, read from lst/nhl95.bin.
revframetbl = $8596		;frames95
setvideo = $A204		;hockey95
SprSort = $A8E6			;setup95_01
setpads = $AB2A			;setup95_01
Z80Program = $BD86		;sound95_01
SoundBanks = $D8EC		;sound95_01
SoundCmd = $676D8		;sound95_01
sfx = $677AC			;sound95_01
SoundOff = $679B2		;sound95_01
DoFill = $79902			;sound95_01
dobitmap = $79A3C		;video95_01
DoDMA_clearCallbackPointer = $79AC0	;video95_01
forceblack = $7A02A		;display95_02
forceblack2 = $7A054		;video95_02
ReadMenuJoy = $7A6AA		;video95_02
vtoa = $7C586			;video95_03
vcountwait = $7C6BE		;video95_03
printz = $7C810			;video95_03
eraser = $7C8CC			;video95_03
InitMenuState = $7E526		;menu95
RestoreGameScreen = $7EBBE	;menu95
ReplayMap = $1625F2		;graphics95_01
ReplayIconMap = $162D18		;graphics95_01

; Main segment code
	include	replay95.asm
