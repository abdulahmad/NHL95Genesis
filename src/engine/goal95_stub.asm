	include	macros\genesis.mac	;String
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
;	Segment stub.
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; region code
	org	$8C304

; includes for stubs to replace removed code
	include	stubinc\ports.inc	;IO_* / VDP_* ports
	include	stubinc\equals.inc	;VDP status bits
	include	ram95.asm		;RAM map

; External addresses outside, read from lst/nhl95.bin.
ZeroLong = $69A
Opening2 = $9ADA
IntermissionStart = $9D18
sfx = $677AC
play_new_song = $67938
ChooseSong = $679C4
setvram = $79936
dobitmap = $79A3C
DoDMA_clearCallbackPointer = $79AC0
forceblack = $7A02A
DecompressGraphicsWithCallback = $7A264
Framer = $7A270
VBlank_SetOptions = $7A418
orjoy = $7A448
nodiag = $7A488
ReadJoy1 = $7A4B0
ReadJoy2 = $7A4C8
ReadJoy3 = $7A4E0
ReadJoy4 = $7A50C
printsmallz = $7C6D4
printsmall = $7C6E6
printz = $7C810
print = $7C822
eraser = $7C8CC
ReadAttributeNibble = $7CB4E
FormatPlayerName = $7CDC2
PushNumberWidth = $7D154
GetPeriodTimeRemaining = $7D762
printscores1 = $7D776
printbigz = $7D8D2
printbig1 = $7D908
assinsert = $81570
assreplace = $8157A
EndOneTimer = $82F60
EncodePW = $8756E
AddPenalty2 = $8916E
RemovePlayerFromList = $8962C
ClearPenaltyBuffer = $89A7C
ClearPenalties = $89A8A
lcfound2 = $8A2FC
ChkShotStat = $8ABDA
SetSPA = $8BC9A
SeasonGameOver = $8EF2A
CountGoalies = $9C564
EndPenaltyShotPlay = $9ECE6
StanleyCupScreen = $A17B8
RosterFont = $1383C6
Teamblocksmap = $142906
BigFontMap2 = $15F46C
ControllerBgMap = $164AC8
ControllerTitleMap = $16AA7C
PadCursorMap = $16AD5A
PadIconMap1 = $16B0B2
PadIconMap2 = $16B1C8
PadIconMap3 = $16B2DE
PadIconMap4 = $16B3F4

; Main segment code
	include	engine\goal95.asm
