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
	include	stubinc\ram_addrs.inc	;RAM names

; External addresses outside $09C6F0-$09DA4F, read from lst/nhl95.bin.
TeamList = $772			;main95
MakeSRAMChecksum = $9908	;sram95
setvram = $79936		;video95_01
dobitmap = $79A3C		;video95_01
forceblack = $7A02A		;display95_02
DecompressGraphicsWithCallback = $7A264	;video95_02
VBlank_SetOptions = $7A418	;video95_02
orjoy = $7A448			;video95_02
ReadJoy1 = $7A4B0		;video95_02
ReadJoy2 = $7A4C8		;video95_02
ReadJoy3 = $7A4E0		;video95_02
ReadJoy4 = $7A50C		;video95_02
ProcessInputWithRepeat = $7A762	;video95_02
randomd0 = $7C63A		;video95_03
printz2 = $7C6D4		;video95_03
printsmall = $7C6E6		;video95_03
printz = $7C810			;video95_03
eraser = $7C8CC			;video95_03
SkipStrings = $7CB42		;video95_03
ReadAttributeNibbleD7 = $7CB60	;video95_03
GetDefenseStartD7 = $7CBB6	;video95_03
FormatFirstNameD7 = $7CE56	;video95_03
FormatLastNameD7 = $7CE8E	;video95_03
GetPlayerCountD7 = $83904	;collide95_02
PlayoffScreen = $87BA2		;data95_01
ReadSeasonHeader = $8E228	;season95
WriteSeasonHeader = $8E246	;season95
ReadStandings = $8F332		;season95
GetRosterName = $9649E		;trade95
SmallFontMap = $139094		;graphics95_01
AwardsBgMap = $17409A		;graphics95_01
FinalistsPanelMap = $1787C8	;graphics95_01
WinnerPanelMap = $178B12	;graphics95_01
HartPic = $178EC6		;graphics95_01
NorrisPic = $179690		;graphics95_01
VezinaPic = $17A94A		;graphics95_01
ArtRossPic = $17B2E8		;graphics95_01
SelkePic = $17BF00		;graphics95_01
JenningsPic = $17E0D6		;graphics95_01
PresidentsPic = $17EE8E		;graphics95_01
ConnSmythePic = $17F76C		;graphics95_01
PearsonPic = $18022A		;graphics95_01

; Main segment code
	include	awards95.asm
