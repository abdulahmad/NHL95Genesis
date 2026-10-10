;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
;	scout95 segment stub. Retail $09F590-$0A00D5.
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; region code
	org	$9F590

; includes for stubs to replace removed code
	include	stubinc\ports.inc	;IO_* / VDP_* ports
	include	stubinc\equals.inc	;VDP status bits
	include	ram95.asm		;RAM map

; External addresses outside $09F590-$0A00D5, read from lst/nhl95.bin.
clearTeamStats = $AE48		;setup95_01
Z80Program = $BD86		;sound95_01
SoundBanks = $D8EC		;sound95_01
SoundCmd = $676D8		;sound95_01
song = $678C2			;sound95_01
play_new_song = $67938		;sound95_01
setvram = $79936		;video95_01
dobitmap = $79A3C		;video95_01
DoDMA_clearCallbackPointer = $79AC0	;video95_01
DecompressGraphicsWithCallback = $7A264	;video95_02
vb2 = $7A3F6			;video95_02
printz2 = $7C6D4		;video95_03
printsmall = $7C6E6		;video95_03
printz = $7C810			;video95_03
eraser = $7C8CC			;video95_03
CalcAttrib = $7CF16		;video95_03
PushNumberWidth = $7D154	;video95_03
ScaleAttrib = $7D258		;video95_03
TeamLogoBitmaps = $7D3F8	;video95_03
waitx = $7D706			;video95_03
printbigz = $7D8D2		;video95_03
UnpackPicture = $7DA78		;video95_03
AnyPadAssigned = $7DFAC		;fourway95
Create_HotCold_Table = $83E88	;collide95_02
PAttribOverallMask = $85846	;data95_01
GAttribOverallMask = $859A8	;data95_01
ReadNameLog = $9B876		;records95
StartScoutText = $A00D6		;setup95_03
ScoutTextPlayer = $A00F0	;setup95_03
PrintPlayerNameRight = $A043E	;setup95_03
CopyHottestPlayer = $A0672	;setup95_03
CopyColdestPlayer = $A0692	;setup95_03
GetTeamRating = $A06B0		;setup95_03
GetHomeUsers = $A08DC		;setup95_03
GetAwayUsers = $A0954		;setup95_03
GetPlayerPicture = $A0A30	;setup95_03
PicturePalette = $A1A5A	;title95_02
SmallFontMap = $139094		;graphics95_01
BigFontMap2 = $15F46C		;graphics95_01
ScoutReportMap = $1891F8	;graphics95_01
HotIconMap = $18A5C6		;graphics95_01
ColdIconMap = $18A78C		;graphics95_01
RonBarrMap = $18A9B2		;graphics95_01
TeamLogoPalettes = $1A169A	;graphics95_01

; Main segment code
	include	scout95.asm
