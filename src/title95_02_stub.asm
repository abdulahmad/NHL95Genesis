;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
;	title95_02 segment stub. Retail $0A12AA-$0A1A59.
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; region code
	org	$A12AA

; includes for stubs to replace removed code
	include	stubinc\ports.inc	;IO_* / VDP_* ports
	include	stubinc\equals.inc	;VDP status bits
	include	stubinc\ram_addrs.inc	;RAM names

; External addresses outside $0A12AA-$0A1A59, read from lst/nhl95.bin.
SoundCmd = $676D8		;sound95_01
song = $678C2			;sound95_01
play_new_song = $67938		;sound95_01
setvram = $79936		;video95_01
setVram_0 = $7994C		;video95_01
dobitmap = $79A3C		;video95_01
DoDMA_clearCallbackPointer = $79AC0	;video95_01
cramfade = $79B54		;video95_01
DoDMA = $79CE6			;video95_01
forceblack = $7A02A		;display95_02
DecompressGraphicsWithCallback = $7A264	;video95_02
p_music_vblank = $7A3E6		;video95_02
vb2 = $7A3F6			;video95_02
orjoy = $7A448			;video95_02
ReadJoy1 = $7A4B0		;video95_02
ReadJoy2 = $7A4C8		;video95_02
ReadJoy3 = $7A4E0		;video95_02
ReadJoy4 = $7A50C		;video95_02
printz = $7C810			;video95_03
print = $7C822			;video95_03
eraser = $7C8CC			;video95_03
waitx = $7D706			;video95_03
RosterFont = $1383C6		;graphics95_01
Teamblocksmap = $142906		;graphics95_01
HiScoreBgMap = $16334A		;graphics95_01
HiScoreImg = $16430A		;graphics95_01
TitleScreenImg = $18DAA8	;graphics95_01
TitleImg = $1960D6		;graphics95_01
StanleyCupImg = $196C4C		;graphics95_01
CupSprites = $19A0FA		;graphics95_01
Credits = $1A6C28		;graphics95_02
CreditsList = $1A6C6A		;credits95

; Main segment code
	include	title95_02.asm
