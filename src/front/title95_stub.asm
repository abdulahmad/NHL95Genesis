;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
;	Segment stub.
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; region code
	org	$A12AA

; includes for stubs to replace removed code
	include	stubinc\ports.inc	;IO_* / VDP_* ports
	include	stubinc\equals.inc	;VDP status bits
	include	ram95.asm		;RAM map

; External addresses outside, read from lst/nhl95.bin.
ZeroLong = $69A
Z80Program = $BD86
SoundBanks = $D8EC
SoundCmd = $676D8
song = $678C2
stop_current_song = $67938
setVram = $79936
setVram_0 = $7994C
dobitmap = $79A3C
DecompressGraphicsPlain = $79AC0
cramfade = $79B54
DoDMA = $79CE6
forceblack = $7A02A
DecompressGraphicsWithCallback = $7A264
p_music_vblank = $7A3E6
vb2 = $7A3F6
orjoy = $7A448
ReadJoy1 = $7A4B0
ReadJoy2 = $7A4C8
ReadJoy3 = $7A4E0
ReadJoy4 = $7A50C
printz = $7C810
print = $7C822
eraser = $7C8CC
waitx = $7D706
RosterFont = $1383C6
Teamblocksmap = $142906
HiScoreBgMap = $16334A
HiScoreImg = $16430A
TitleScreenImg = $18DAA8
TitleImg = $1960D6
StanleyCupImg = $196C4C
CupSprites = $19A0FA
Credits = $1A6C28
CreditsList = $1A6C6A

; Main segment code
	include	front\title95.asm
