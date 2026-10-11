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
SeasonSchedule = $8DD8		;frames95
WriteSRAM = $98E6		;sram95
MakeSRAMChecksum = $9908	;sram95
ReadSRAM = $9952		;sram95
Opening2 = $9ADA		;hockey95
clearTeamStats = $AE48		;setup95_01
setvram = $79936		;video95_01
dobitmap = $79A3C		;video95_01
DoDMA_clearCallbackPointer = $79AC0	;video95_01
forceblack = $7A02A		;video95_01
DecompressGraphicsWithCallback = $7A264	;video95_01
Framer = $7A270			;video95_01
VBlank_SetOptions = $7A418	;video95_01
orjoy = $7A448			;video95_01
ReadJoy1 = $7A4B0		;video95_01
ReadJoy2 = $7A4C8		;video95_01
ReadJoy3 = $7A4E0		;video95_01
ReadJoy4 = $7A50C		;video95_01
ProcessInputWithRepeat = $7A762	;video95_01
printz2 = $7C6D4		;video95_02
printsmall = $7C6E6		;video95_02
printz = $7C810			;video95_02
eraser = $7C8CC			;video95_02
PrintSmallListItem = $7CB38	;video95_02
ReadAttributeNibbleD7 = $7CB60	;video95_02
GetDefenseStartD7 = $7CBB6	;video95_02
FormatPlayerInitialD7 = $7CCF4	;video95_02
FormatPlayerNameWithAttribD7 = $7CD2C	;video95_02
FormatPlayerNameD7 = $7CD82	;video95_02
CalcAttrib = $7CF16		;video95_02
PushNumberWidth = $7D154	;video95_02
ScaleAttrib = $7D258		;video95_02
TeamLogoBitmaps = $7D3F8	;video95_02
printbigz = $7D8D2		;video95_02
SeasonPlayerOut = $7DBD8	;video95_02
GetPlayerCountD7 = $83904	;collide95_02
PAttribOverallMask = $85846	;optsetup95
GAttribOverallMask = $859A8	;optsetup95
CheckSavedLines = $8A79A	;checks95_04
ReadTeamPlayerStats = $93226	;stats95_01
WriteTeamPlayerStats = $932F8	;stats95_01
CreateScreenGfx = $97C54	;create95
SetInjuryGames = $9F1EA		;checks95_05
GetInjuryGames = $9F232		;checks95_05
InsertInjurySlot = $9F3B8		;checks95_05
DeleteInjurySlot = $9F40E		;checks95_05
SmallFontMap = $139094		;graphics95_01
Teamblocksmap = $142906		;graphics95_01
Framermap = $14C148		;graphics95_01
BigFontMap2 = $15F46C		;graphics95_01
TradeBgMap = $172CCC		;graphics95_01
GMDecisionMap = $180D54		;graphics95_01
TradeAdvantageMap2 = $181B04	;graphics95_01
TradeAdvantageMap1 = $18277C	;graphics95_01
TeamLogoPalettes = $1A169A	;graphics95_01

; Main segment code
	include	trade95.asm
