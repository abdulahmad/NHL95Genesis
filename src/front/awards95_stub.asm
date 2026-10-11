;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
;	Segment stub.
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; region code
	org	$9C6F0

; includes for stubs to replace removed code
	include	stubinc\ports.inc	;IO_* / VDP_* ports
	include	stubinc\equals.inc	;VDP status bits
	include	ram95.asm		;RAM map

; External addresses outside, read from lst/nhl95.bin.
TeamList = $772
MakeSRAMChecksum = $9908
setVram = $79936
dobitmap = $79A3C
forceblack = $7A02A
DecompressGraphicsWithCallback = $7A264
VBlank_SetOptions = $7A418
orjoy = $7A448
ReadJoy1 = $7A4B0
ReadJoy2 = $7A4C8
ReadJoy3 = $7A4E0
ReadJoy4 = $7A50C
ProcessInputWithRepeat = $7A762
randomd0 = $7C63A
printsmallz = $7C6D4
printsmall = $7C6E6
printz = $7C810
eraser = $7C8CC
AdvanceStringPtr = $7CB42
ReadAttributeNibbleD7 = $7CB60
GetDefenseStartD7 = $7CBB6
FormatFirstNameD7 = $7CE56
FormatLastNameD7 = $7CE8E
GetPlayerCountD7 = $83904
PlayoffScreen = $87BA2
ReadSeasonHeader = $8E228
WriteSeasonHeader = $8E246
ReadStandings = $8F332
GetRosterName = $9649E
SmallFontMap = $139094
AwardsBgMap = $17409A
FinalistsPanelMap = $1787C8
WinnerPanelMap = $178B12
HartPic = $178EC6
NorrisPic = $179690
VezinaPic = $17A94A
ArtRossPic = $17B2E8
SelkePic = $17BF00
JenningsPic = $17E0D6
PresidentsPic = $17EE8E
ConnSmythePic = $17F76C
PearsonPic = $18022A

; Main segment code
	include	front\awards95.asm
