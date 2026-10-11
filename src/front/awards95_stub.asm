;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
;	awards95 segment stub. Retail $09C6F0-$09DA4F.
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; region code
	org	$9C6F0

; includes for stubs to replace removed code
	include	stubinc\ports.inc	;IO_* / VDP_* ports
	include	stubinc\equals.inc	;VDP status bits
	include	ram95.asm		;RAM map

; External addresses outside $09C6F0-$09DA4F, read from lst/nhl95.bin.
TeamList = $772			;main95
MakeSRAMChecksum = $9908	;sram95
setvram = $79936		;video95
dobitmap = $79A3C		;video95
forceblack = $7A02A		;video95
DecompressGraphicsWithCallback = $7A264	;video95
VBlank_SetOptions = $7A418	;video95
orjoy = $7A448			;video95
ReadJoy1 = $7A4B0		;video95
ReadJoy2 = $7A4C8		;video95
ReadJoy3 = $7A4E0		;video95
ReadJoy4 = $7A50C		;video95
ProcessInputWithRepeat = $7A762	;video95
randomd0 = $7C63A		;middle95
printsmallz = $7C6D4		;middle95
printsmall = $7C6E6		;middle95
printz = $7C810			;middle95
eraser = $7C8CC			;middle95
SkipStrings = $7CB42		;middle95
ReadAttributeNibbleD7 = $7CB60	;middle95
GetDefenseStartD7 = $7CBB6	;middle95
FormatFirstNameD7 = $7CE56	;middle95
FormatLastNameD7 = $7CE8E	;middle95
GetPlayerCountD7 = $83904	;players95
PlayoffScreen = $87BA2		;setup95
ReadSeasonHeader = $8E228	;season95
WriteSeasonHeader = $8E246	;season95
ReadStandings = $8F332		;season95
GetRosterName = $9649E		;trade95
SmallFontMap = $139094		;graphics95
AwardsBgMap = $17409A		;graphics95
FinalistsPanelMap = $1787C8	;graphics95
WinnerPanelMap = $178B12	;graphics95
HartPic = $178EC6		;graphics95
NorrisPic = $179690		;graphics95
VezinaPic = $17A94A		;graphics95
ArtRossPic = $17B2E8		;graphics95
SelkePic = $17BF00		;graphics95
JenningsPic = $17E0D6		;graphics95
PresidentsPic = $17EE8E		;graphics95
ConnSmythePic = $17F76C		;graphics95
PearsonPic = $18022A		;graphics95

; Main segment code
	include	front\awards95.asm
