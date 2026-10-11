;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
;	trade95 segment stub. Retail $0962EE-$097C53.
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; region code
	org	$962EE

; includes for stubs to replace removed code
	include	stubinc\ports.inc	;IO_* / VDP_* ports
	include	stubinc\equals.inc	;VDP status bits
	include	ram95.asm		;RAM map

; External addresses outside $0962EE-$097C53, read from lst/nhl95.bin.
ZeroLong = $69A			;main95
TeamList = $772			;main95
SeasonSchedule = $8DD8
WriteSRAM = $98E6
MakeSRAMChecksum = $9908
ReadSRAM = $9952
Opening2 = $9ADA
clearTeamStats = $AE48
setvram = $79936
dobitmap = $79A3C
DoDMA_clearCallbackPointer = $79AC0
forceblack = $7A02A
DecompressGraphicsWithCallback = $7A264
Framer = $7A270
VBlank_SetOptions = $7A418
orjoy = $7A448
ReadJoy1 = $7A4B0
ReadJoy2 = $7A4C8
ReadJoy3 = $7A4E0
ReadJoy4 = $7A50C
ProcessInputWithRepeat = $7A762
printsmallz = $7C6D4
printsmall = $7C6E6
printz = $7C810
eraser = $7C8CC
PrintSmallListItem = $7CB38
ReadAttributeNibbleD7 = $7CB60
GetDefenseStartD7 = $7CBB6
FormatPlayerInitialD7 = $7CCF4
FormatPlayerNameWithAttribD7 = $7CD2C
FormatPlayerNameD7 = $7CD82
CalcAttrib = $7CF16
PushNumberWidth = $7D154
AttribAdjust = $7D258
TeamLogoBitmaps = $7D3F8
printbigz = $7D8D2
SeasonPlayerOut = $7DBD8
GetPlayerCountD7 = $83904
PAttribOverallMask = $85846
GAttribOverallMask = $859A8
CheckSavedLines = $8A79A
ReadTeamPlayerStats = $93226
WriteTeamPlayerStats = $932F8
CreateScreenGfx = $97C54
SetInjuryGames = $9F1EA
GetInjuryGames = $9F232
InsertInjurySlot = $9F3B8
DeleteInjurySlot = $9F40E
SmallFontMap = $139094
Teamblocksmap = $142906
Framermap = $14C148
BigFontMap2 = $15F46C
TradeBgMap = $172CCC
GMDecisionMap = $180D54
TradeAdvantageMap2 = $181B04
TradeAdvantageMap1 = $18277C
TeamLogoPalettes = $1A169A

; Main segment code
	include	front\trade95.asm
