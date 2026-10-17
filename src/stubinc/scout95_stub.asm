;	Segment build for scout95.asm: sets its origin and the outside routines and data it uses,
;	then includes scout95.asm on its own for checking against the ROM.

	include	macros\genesis.mac		;String
; region code
	org	$9F590

; includes for stubs to replace removed code
	include	stubinc\ports.inc		;IO_* / VDP_* ports
	include	stubinc\equals.inc		;VDP status bits
	include	ram95.asm				;RAM map

; External addresses outside, read from lst/nhl95.bin.
ZeroLong = $69A
TeamList = $772
clearTeamStats = $AE48
Z80Program = $BD86
SoundBanks = $D8EC
SoundCmd = $676D8
song = $678C2
stop_current_song = $67938
setVram = $79936
dobitmap = $79A3C
DecompressGraphicsPlain = $79AC0
DecompressGraphicsWithCallback = $7A264
vb2 = $7A3F6
printsmallz = $7C6D4
printsmall = $7C6E6
printz = $7C810
print = $7C822
eraser = $7C8CC
GetGoalieCountD7 = $7CB60
FormatPlayerName = $7CDC2
CalcAttrib = $7CF16
PushNumberWidth = $7D154
AttribAdjust = $7D258
DoDMA_nd2 = $7D35E
TeamLogoBitmaps = $7D3F8
waitx = $7D706
printbigz = $7D8D2
UnpackPicture = $7DA78
AnyPadAssigned = $7DFAC
Create_HotCold_Table = $83E88
PAttribOverallMask = $85846
GAttribOverallMask = $859A8
GetRosterId = $96454
GetCreatedName = $96494
GetLogName = $9B50E
ReadNameLog = $9B876
PicturePalette = $A1A5A
NoPicSkater2 = $A1E90
NoPicSkater1 = $A21FA
NoPicGoalie2 = $A2564
NoPicGoalie1 = $A28CE
FeaturedPicIdx = $C4754
FeaturedPictures = $C47FC
SmallFontMap = $139094
BigFontMap2 = $15F46C
ScoutReportMap = $1891F8
HotIconMap = $18A5C6
ColdIconMap = $18A78C
RonBarrMap = $18A9B2
TeamLogoPalettes = $1A169A

; Main segment code
	include	front\scout95.asm
