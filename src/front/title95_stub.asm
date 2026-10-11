;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
;	title95 segment stub. Retail $0A12AA-$0A1A59.
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; region code
	org	$A12AA

; includes for stubs to replace removed code
	include	stubinc\ports.inc	;IO_* / VDP_* ports
	include	stubinc\equals.inc	;VDP status bits
	include	ram95.asm		;RAM map

; External addresses outside $0A12AA-$0A1A59, read from lst/nhl95.bin.
ZeroLong = $69A			;main95
Z80Program = $BD86		;sound95
SoundBanks = $D8EC		;sound95
SoundCmd = $676D8		;sound95
song = $678C2			;sound95
play_new_song = $67938		;sound95
setvram = $79936		;video95
setVram_0 = $7994C		;video95
dobitmap = $79A3C		;video95
DoDMA_clearCallbackPointer = $79AC0	;video95
cramfade = $79B54		;video95
DoDMA = $79CE6			;video95
forceblack = $7A02A		;video95
DecompressGraphicsWithCallback = $7A264	;video95
p_music_vblank = $7A3E6		;video95
vb2 = $7A3F6			;video95
orjoy = $7A448			;video95
ReadJoy1 = $7A4B0		;video95
ReadJoy2 = $7A4C8		;video95
ReadJoy3 = $7A4E0		;video95
ReadJoy4 = $7A50C		;video95
printz = $7C810			;middle95
print = $7C822			;middle95
eraser = $7C8CC			;middle95
waitx = $7D706			;middle95
RosterFont = $1383C6		;graphics95
Teamblocksmap = $142906		;graphics95
HiScoreBgMap = $16334A		;graphics95
HiScoreImg = $16430A		;graphics95
TitleScreenImg = $18DAA8	;graphics95
TitleImg = $1960D6		;graphics95
StanleyCupImg = $196C4C		;graphics95
CupSprites = $19A0FA		;graphics95
Credits = $1A6C28		;arena95
CreditsList = $1A6C6A		;credits95

; Main segment code
	include	front\title95.asm
