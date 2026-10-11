;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
;	create95 segment stub. Retail $097C54-$09ACE5.
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; region code
	org	$97C54

; includes for stubs to replace removed code
	include	stubinc\ports.inc	;IO_* / VDP_* ports
	include	stubinc\equals.inc	;VDP status bits
	include	ram95.asm		;RAM map

; External addresses outside $097C54-$09ACE5, read from lst/nhl95.bin.
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
printz2 = $7C6D4		;middle95
printsmall = $7C6E6		;middle95
printz = $7C810			;middle95
print = $7C822			;middle95
eraser = $7C8CC			;middle95
PrintSmallListItem = $7CB38	;middle95
ReadAttributeNibbleD7 = $7CB60	;middle95
GetDefenseStartD7 = $7CBB6	;middle95
ProcessNibbleD7 = $7CC08	;middle95
FormatPlayerNameD7 = $7CD82	;middle95
CalcAttribRating = $7CF78	;middle95
OvrPlayerWgtList = $7D08C	;middle95
OvrGoalWgtList = $7D09C		;middle95
AttribWgtList = $7D0AC		;middle95
PushNumberWidth = $7D154	;middle95
SetRinkPalette = $7D6F0		;middle95
printbigz = $7D8D2		;middle95
GetPlayerCountD7 = $83904	;players95
StickHandTable = $83C9E	;players95
PAttribOverallMask = $85846	;setup95
GAttribOverallMask = $859A8	;setup95
CheckSavedLines = $8A79A	;lines95
ReadTeamPlayerStats = $93226	;stats95
WriteTeamPlayerStats = $932F8	;stats95
MarkSeasonRosters = $93430	;stats95
GetCreatedName = $96494		;trade95
GetJerseyNumber = $965A8	;trade95
MoveTradedPlayer = $9684A	;trade95
RemoveTradedPlayer = $96A54	;trade95
TradeRulesText = $97338		;trade95
TradeGfx = $9743A		;trade95
DrawTradeLogo = $9757C		;trade95
DrawTradeTeam = $975AC		;trade95
SmallFontMap = $139094		;graphics95
Teamblocksmap = $142906		;graphics95
Framermap = $14C148		;graphics95
BigFontMap2 = $15F46C		;graphics95
ControllerBgMap = $164AC8	;graphics95
CreateBgMap = $1703FE		;graphics95
TradeBgMap = $172CCC		;graphics95
FreeAgentMap2 = $181078		;graphics95
FreeAgentMap1 = $181486		;graphics95
NameEntryBgMap = $1834F4	;graphics95

; Main segment code
	include	front\create95.asm
