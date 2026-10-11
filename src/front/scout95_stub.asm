	include	macros\genesis.mac	;String (main95.asm includes it in the full build)
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
;	scout95 segment stub. Retail $09F590-$0A0B3D.
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; region code
	org	$9F590

; includes for stubs to replace removed code
	include	stubinc\ports.inc	;IO_* / VDP_* ports
	include	stubinc\equals.inc	;VDP status bits
	include	ram95.asm		;RAM map

; External addresses outside $09F590-$0A0B3D, read from lst/nhl95.bin.
ZeroLong = $69A		;main95
TeamList = $772		;teamdata95
clearTeamStats = $AE48		;control95
Z80Program = $BD86		;sound95
SoundBanks = $D8EC		;sound95
SoundCmd = $676D8		;sound95
song = $678C2		;sound95
play_new_song = $67938		;sound95
setvram = $79936		;video95
dobitmap = $79A3C		;video95
DoDMA_clearCallbackPointer = $79AC0		;video95
DecompressGraphicsWithCallback = $7A264		;video95
vb2 = $7A3F6		;video95
printsmallz = $7C6D4		;middle95
printsmall = $7C6E6		;middle95
printz = $7C810		;middle95
print = $7C822		;middle95
eraser = $7C8CC		;middle95
ReadAttributeNibbleD7 = $7CB60		;middle95
FormatPlayerName = $7CDC2		;middle95
CalcAttrib = $7CF16		;middle95
PushNumberWidth = $7D154		;middle95
AttribAdjust = $7D258		;middle95
DoDMA_nd2 = $7D35E		;middle95
TeamLogoBitmaps = $7D3F8		;middle95
waitx = $7D706		;middle95
printbigz = $7D8D2		;middle95
UnpackPicture = $7DA78		;middle95
AnyPadAssigned = $7DFAC		;fourway95
Create_HotCold_Table = $83E88		;players95
PAttribOverallMask = $85846		;setup95
GAttribOverallMask = $859A8		;setup95
GetRosterId = $96454		;trade95
GetCreatedName = $96494		;create95
GetLogName = $9B50E		;records95
ReadNameLog = $9B876		;records95
PicturePalette = $A1A5A		;title95
NoPicSkater2 = $A1E90		;graphics95
NoPicSkater1 = $A21FA		;graphics95
NoPicGoalie2 = $A2564		;graphics95
NoPicGoalie1 = $A28CE		;graphics95
FeaturedPicIdx = $C4754		;graphics95
FeaturedPictures = $C47FC		;graphics95
SmallFontMap = $139094		;graphics95
BigFontMap2 = $15F46C		;graphics95
ScoutReportMap = $1891F8		;graphics95
HotIconMap = $18A5C6		;graphics95
ColdIconMap = $18A78C		;graphics95
RonBarrMap = $18A9B2		;graphics95
TeamLogoPalettes = $1A169A		;graphics95

; Main segment code
	include	front\scout95.asm
