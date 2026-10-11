	include	macros\genesis.mac	;String (main95.asm includes it in the full build)
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
;	goal95 segment stub. Retail $08C304-$08D399.
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; region code
	org	$8C304

; includes for stubs to replace removed code
	include	stubinc\ports.inc	;IO_* / VDP_* ports
	include	stubinc\equals.inc	;VDP status bits
	include	ram95.asm		;RAM map

; External addresses outside $08C304-$08D399, read from lst/nhl95.bin.
ZeroLong = $69A		;main95
Opening2 = $9ADA		;hockey95
IntermissionStart = $9D18		;hockey95
sfx = $677AC		;sound95
play_new_song = $67938		;sound95
ChooseSong = $679C4		;sound95
setvram = $79936		;video95
dobitmap = $79A3C		;video95
DoDMA_clearCallbackPointer = $79AC0		;video95
forceblack = $7A02A		;video95
DecompressGraphicsWithCallback = $7A264		;video95
Framer = $7A270		;video95
VBlank_SetOptions = $7A418		;video95
orjoy = $7A448		;video95
nodiag = $7A488		;video95
ReadJoy1 = $7A4B0		;video95
ReadJoy2 = $7A4C8		;video95
ReadJoy3 = $7A4E0		;video95
ReadJoy4 = $7A50C		;video95
printsmallz = $7C6D4		;middle95
printsmall = $7C6E6		;middle95
printz = $7C810		;middle95
print = $7C822		;middle95
eraser = $7C8CC		;middle95
ReadAttributeNibble = $7CB4E		;middle95
FormatPlayerName = $7CDC2		;middle95
PushNumberWidth = $7D154		;middle95
GetPeriodTimeRemaining = $7D762		;middle95
printscores1 = $7D776		;middle95
printbigz = $7D8D2		;middle95
printbig1 = $7D908		;middle95
assinsert = $81570		;logic95
assreplace = $8157A		;logic95
EndOneTimer = $82F60		;logic95
EncodePW = $8756E		;setup95
AddPenalty2 = $8916E		;penalty95
RemovePlayerFromList = $8962C		;penalty95
ClearPenaltyBuffer = $89A7C		;penalty95
ClearPenalties = $89A8A		;penalty95
lcfound2 = $8A2FC		;lines95
ChkShotStat = $8ABDA		;lines95
SetSPA = $8BC9A		;skate95
SeasonGameOver = $8EF2A		;season95
CountGoalies = $9C564		;records95
EndPenaltyShotPlay = $9ECE6		;shootout95
StanleyCupScreen = $A17B8		;title95
RosterFont = $1383C6		;graphics95
Teamblocksmap = $142906		;graphics95
BigFontMap2 = $15F46C		;graphics95
ControllerBgMap = $164AC8		;graphics95
ControllerTitleMap = $16AA7C		;graphics95
PadCursorMap = $16AD5A		;graphics95
PadIconMap1 = $16B0B2		;graphics95
PadIconMap2 = $16B1C8		;graphics95
PadIconMap3 = $16B2DE		;graphics95
PadIconMap4 = $16B3F4		;graphics95

; Main segment code
	include	engine\goal95.asm
