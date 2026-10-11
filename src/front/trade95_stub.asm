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
clearTeamStats = $AE48		;control95
setvram = $79936		;video95
dobitmap = $79A3C		;video95
DoDMA_clearCallbackPointer = $79AC0	;video95
forceblack = $7A02A		;video95
DecompressGraphicsWithCallback = $7A264	;video95
Framer = $7A270			;video95
VBlank_SetOptions = $7A418	;video95
orjoy = $7A448			;video95
ReadJoy1 = $7A4B0		;video95
ReadJoy2 = $7A4C8		;video95
ReadJoy3 = $7A4E0		;video95
ReadJoy4 = $7A50C		;video95
ProcessInputWithRepeat = $7A762	;video95
printsmallz = $7C6D4		;middle95
printsmall = $7C6E6		;middle95
printz = $7C810			;middle95
eraser = $7C8CC			;middle95
PrintSmallListItem = $7CB38	;middle95
ReadAttributeNibbleD7 = $7CB60	;middle95
GetDefenseStartD7 = $7CBB6	;middle95
FormatPlayerInitialD7 = $7CCF4	;middle95
FormatPlayerNameWithAttribD7 = $7CD2C	;middle95
FormatPlayerNameD7 = $7CD82	;middle95
CalcAttrib = $7CF16		;middle95
PushNumberWidth = $7D154	;middle95
ScaleAttrib = $7D258		;middle95
TeamLogoBitmaps = $7D3F8	;middle95
printbigz = $7D8D2		;middle95
SeasonPlayerOut = $7DBD8	;middle95
GetPlayerCountD7 = $83904	;players95
PAttribOverallMask = $85846	;setup95
GAttribOverallMask = $859A8	;setup95
CheckSavedLines = $8A79A	;lines95
ReadTeamPlayerStats = $93226	;stats95
WriteTeamPlayerStats = $932F8	;stats95
CreateScreenGfx = $97C54	;create95
SetInjuryGames = $9F1EA		;injury95
GetInjuryGames = $9F232		;injury95
InsertInjurySlot = $9F3B8		;injury95
DeleteInjurySlot = $9F40E		;injury95
SmallFontMap = $139094		;graphics95
Teamblocksmap = $142906		;graphics95
Framermap = $14C148		;graphics95
BigFontMap2 = $15F46C		;graphics95
TradeBgMap = $172CCC		;graphics95
GMDecisionMap = $180D54		;graphics95
TradeAdvantageMap2 = $181B04	;graphics95
TradeAdvantageMap1 = $18277C	;graphics95
TeamLogoPalettes = $1A169A	;graphics95

; Main segment code
	include	front\trade95.asm
