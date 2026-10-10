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
	include	stubinc\ram_addrs.inc	;RAM names

; External addresses outside $097C54-$09ACE5, read from lst/nhl95.bin.
WriteSRAM = $98E6		;sram95
MakeSRAMChecksum = $9908	;sram95
ReadSRAM = $9952		;sram95
Opening2 = $9ADA		;hockey95
clearTeamStats = $AE48		;setup95_01
setvram = $79936		;video95_01
dobitmap = $79A3C		;video95_01
DoDMA_clearCallbackPointer = $79AC0	;video95_01
forceblack = $7A02A		;display95_02
DecompressGraphicsWithCallback = $7A264	;video95_02
Framer = $7A270			;video95_02
VBlank_SetOptions = $7A418	;video95_02
orjoy = $7A448			;video95_02
ReadJoy1 = $7A4B0		;video95_02
ReadJoy2 = $7A4C8		;video95_02
ReadJoy3 = $7A4E0		;video95_02
ReadJoy4 = $7A50C		;video95_02
ProcessInputWithRepeat = $7A762	;video95_02
printz2 = $7C6D4		;video95_03
printsmall = $7C6E6		;video95_03
printz = $7C810			;video95_03
print = $7C822			;video95_03
eraser = $7C8CC			;video95_03
PrintSmallListItem = $7CB38	;video95_03
ReadAttributeNibbleD7 = $7CB60	;video95_03
GetDefenseStartD7 = $7CBB6	;video95_03
ProcessNibbleD7 = $7CC08	;video95_03
FormatPlayerNameD7 = $7CD82	;video95_03
CalcAttribRating = $7CF78	;video95_03
OvrPlayerWgtList = $7D08C	;video95_03
OvrGoalWgtList = $7D09C		;video95_03
AttribWgtList = $7D0AC		;video95_03
PushNumberWidth = $7D154	;video95_03
SetRinkPalette = $7D6F0		;video95_03
printbigz = $7D8D2		;video95_03
GetPlayerCountD7 = $83904	;collide95_02
StickHandTable = $83C9E	;collide95_02
PAttribOverallMask = $85846	;data95_01
GAttribOverallMask = $859A8	;data95_01
CheckSavedLines = $8A79A	;checks95_05
ReadTeamPlayerStats = $93226	;stats95_01
WriteTeamPlayerStats = $932F8	;stats95_01
MarkSeasonRosters = $93430	;stats95_01
GetCreatedName = $96494		;trade95
GetJerseyNumber = $965A8	;trade95
MoveTradedPlayer = $9684A	;trade95
RemoveTradedPlayer = $96A54	;trade95
TradeRulesText = $97338		;trade95
TradeGfx = $9743A		;trade95
DrawTradeLogo = $9757C		;trade95
DrawTradeTeam = $975AC		;trade95
SmallFontMap = $139094		;graphics95_01
Teamblocksmap = $142906		;graphics95_01
Framermap = $14C148		;graphics95_01
BigFontMap2 = $15F46C		;graphics95_01
ControllerBgMap = $164AC8	;graphics95_01
CreateBgMap = $1703FE		;graphics95_01
TradeBgMap = $172CCC		;graphics95_01
FreeAgentMap2 = $181078		;graphics95_01
FreeAgentMap1 = $181486		;graphics95_01
NameEntryBgMap = $1834F4	;graphics95_01

; Main segment code
	include	create95.asm
