;	Segment build for replay95.asm: sets its origin and the outside routines and data it uses,
;	then includes replay95.asm on its own for checking against the ROM.

; region code
	org	$8D39A

; includes for stubs to replace removed code
	include	stubinc\ports.inc		;IO_* / VDP_* ports
	include	stubinc\equals.inc		;VDP status bits
	include	ram95.asm				;RAM map

; External addresses outside, read from lst/nhl95.bin.
SPAblock = $1E6C
SPFpuck = $1B3
SPFfaceoff = $41A
SPFbglass = $3E8
SPFPen = $3ED
ZeroLong = $69A
revframetbl = $8596
setvideo = $A204
SprSort = $A8E6
setpads = $AB2A
Z80Program = $BD86
SoundBanks = $D8EC
SoundCmd = $676D8
sfx = $677AC
SoundOff = $679B2
DoFill = $79902
dobitmap = $79A3C
DecompressGraphicsPlain = $79AC0
forceblack = $7A02A
forceblack2 = $7A054
ReadMenuJoy = $7A6AA
vtoa = $7C586
vcountwait = $7C6BE
printz = $7C810
eraser = $7C8CC
Pausemode_top = $7E526
RestoreGameScreen = $7EBBE
ReplayMap = $1625F2
ReplayIconMap = $162D18

; Main segment code
	include	engine\replay95.asm
