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
ZeroLong = $69A			;main95
revframetbl = $8596		;frames95
setvideo = $A204		;display95
SprSort = $A8E6			;display95
setpads = $AB2A			;control95
Z80Program = $BD86		;sound95
SoundBanks = $D8EC		;sound95
SoundCmd = $676D8		;sound95
sfx = $677AC			;sound95
SoundOff = $679B2		;sound95
DoFill = $79902			;sound95
dobitmap = $79A3C		;video95
DoDMA_clearCallbackPointer = $79AC0	;video95
forceblack = $7A02A		;video95
forceblack2 = $7A054		;video95
ReadMenuJoy = $7A6AA		;video95
vtoa = $7C586			;middle95
vcountwait = $7C6BE		;middle95
printz = $7C810			;middle95
eraser = $7C8CC			;middle95
InitMenuState = $7E526		;pause95
RestoreGameScreen = $7EBBE	;pause95
ReplayMap = $1625F2		;graphics95
ReplayIconMap = $162D18		;graphics95

; Main segment code
	include	engine\replay95.asm
