	include	macros\genesis.mac	;String (main95.asm includes it in the full build)
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
;	checks95_06 segment stub. Retail $08B9A8-$08D399.
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; region code
	org	$8B9A8

; includes for stubs to replace removed code
	include	stubinc\ports.inc	;IO_* / VDP_* ports
	include	stubinc\equals.inc	;VDP status bits
	include	stubinc\ram_addrs.inc	;RAM names

; External addresses outside $08B9A8-$08D399, read from lst/nhl95.bin.
Opening2 = $9ADA		;hockey95
IntermissionStart = $9D18	;hockey95
sfx = $677AC			;sound95_01
play_new_song = $67938		;sound95_01
ChooseSong = $679C4		;sound95_01
setvram = $79936		;video95_01
dobitmap = $79A3C		;video95_01
DoDMA_clearCallbackPointer = $79AC0	;video95_01
forceblack = $7A02A		;display95_02
DecompressGraphicsWithCallback = $7A264	;video95_02
Framer = $7A270			;video95_02
VBlank_SetOptions = $7A418	;video95_02
orjoy = $7A448			;video95_02
nodiag = $7A488			;video95_02
ReadJoy1 = $7A4B0		;video95_02
ReadJoy2 = $7A4C8		;video95_02
ReadJoy3 = $7A4E0		;video95_02
ReadJoy4 = $7A50C		;video95_02
vtoa = $7C586			;video95_03
printz2 = $7C6D4		;video95_03
printsmall = $7C6E6		;video95_03
printz = $7C810			;video95_03
print = $7C822			;video95_03
eraser = $7C8CC			;video95_03
getpde = $7CAD0			;video95_03
ReadAttributeNibble = $7CB4E	;video95_03
FormatPlayerName = $7CDC2	;video95_03
PushNumberWidth = $7D154	;video95_03
GetPeriodTimeRemaining = $7D762	;video95_03
PrintScores1 = $7D776		;video95_03
printbigz = $7D8D2		;video95_03
printbig1 = $7D908		;video95_03
setpde = $7DBCA			;video95_03
assinsert = $81570		;checks95_02
assreplace = $8157A		;checks95_02
EndOneTimer = $82F60		;onetimer95
EncodePW = $8756E		;data95_01
AddPenalty2 = $8916E		;penalty95
RemovePlayerFromList = $8962C	;penalty95
ClearPenaltyBuffer = $89A7C	;data95_02
ClearPenalties = $89A8A		;data95_02
lcfound2 = $8A2FC		;input95_02
ChkShotStat = $8ABDA		;checks95_05
goalieacc = $8B4E0		;checks95_05
SeasonGameOver = $8EF2A		;season95
CountGoalies = $9C564		;cards95_02
EndPenaltyShotPlay = $9ECE6		;checks95_07
StanleyCupScreen = $A17B8	;title95_02
RosterFont = $1383C6		;graphics95_01
Teamblocksmap = $142906		;graphics95_01
BigFontMap2 = $15F46C		;graphics95_01
ControllerBgMap = $164AC8	;graphics95_01
ControllerTitleMap = $16AA7C	;graphics95_01
PadCursorMap = $16AD5A		;graphics95_01
PadIconMap1 = $16B0B2		;graphics95_01
PadIconMap2 = $16B1C8		;graphics95_01
PadIconMap3 = $16B2DE		;graphics95_01
PadIconMap4 = $16B3F4		;graphics95_01

; Main segment code
	include	checks95_06.asm
