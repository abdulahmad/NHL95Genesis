;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
;	Segment stub.
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; region code
	org	$97C54

; includes for stubs to replace removed code
	include	stubinc\ports.inc	;IO_* / VDP_* ports
	include	stubinc\equals.inc	;VDP status bits
	include	ram95.asm		;RAM map

; External addresses outside, read from lst/nhl95.bin.
WriteSRAM = $98E6
MakeSRAMChecksum = $9908
ReadSRAM = $9952
Opening2 = $9ADA
clearTeamStats = $AE48
setVram = $79936
dobitmap = $79A3C
DecompressGraphicsPlain = $79AC0
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
print = $7C822
eraser = $7C8CC
PrintSmallListItem = $7CB38
GetGoalieCountD7 = $7CB60
GetDefenseStartD7 = $7CBB6
GetForwardCountD7 = $7CC08
FormatPlayerNameD7 = $7CD82
CalcAttribRating = $7CF78
OvrPlayerWgtList = $7D08C
OvrGoalWgtList = $7D09C
AttribWgtList = $7D0AC
PushNumberWidth = $7D154
setupIceRinkPal = $7D6F0
printbigz = $7D8D2
GetPlayerCountD7 = $83904
StickHandTable = $83C9E
PAttribOverallMask = $85846
GAttribOverallMask = $859A8
CheckSavedLines = $8A79A
ReadTeamPlayerStats = $93226
WriteTeamPlayerStats = $932F8
MarkSeasonRosters = $93430
GetCreatedName = $96494
GetJerseyNumber = $965A8
MoveTradedPlayer = $9684A
RemoveTradedPlayer = $96A54
TradeRulesText = $97338
TradeGfx = $9743A
DrawTradeLogo = $9757C
DrawTradeTeam = $975AC
SmallFontMap = $139094
Teamblocksmap = $142906
Framermap = $14C148
BigFontMap2 = $15F46C
ControllerBgMap = $164AC8
CreateBgMap = $1703FE
TradeBgMap = $172CCC
FreeAgentMap2 = $181078
FreeAgentMap1 = $181486
NameEntryBgMap = $1834F4

; Main segment code
	include	front\create95.asm
