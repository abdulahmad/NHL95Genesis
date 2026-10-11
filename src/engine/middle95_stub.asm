	include	macros\genesis.mac	;String
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
;	Segment stub.
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; region code
	org	$7C512

; includes for stubs to replace removed code
	include	stubinc\ports.inc	;IO_* / VDP_* ports
	include	stubinc\equals.inc	;VDP status bits
	include	ram95.asm		;RAM map

; External addresses outside, read from lst/nhl95.bin.
ZeroLong = $69A
TeamList = $772
ReadSRAM = $9952
defaultsprites = $A656
SprSort = $A8E6
chgplayer = $AB4E
setc1player = $AD80
setc2player = $AD8A
setc3player = $AD96
setc4player = $ADA2
setplayercolors = $AF1A
SoundCmd = $676D8
DoFill = $79902
setVram = $79936
Vmaddr = $79A22
dobitmap = $79A3C
DoDMA_clearCallbackPointer = $79AC0
WaitDMA = $79B12
xyVmMap = $79C18
DoDMAList = $79CA8
rtss2 = $79CC8		;asstab entry 0, the shared rts
addframe2 = $79DA8
AddSmallFont = $7A256
Framer = $7A270
AddFramer = $7A2EC
AddFramer2 = $7A310
VBlank = $7A332
ReadJoy1 = $7A4B0
ReadJoy2 = $7A4C8
ReadJoy3 = $7A4E0
ReadJoy4 = $7A50C
StickHandTable = $83C9E		;CalcAttrib, attribute 5 (stick handling) scale
PAttribOverallMask = $85846
GAttribOverallMask = $859A8
getGoalieSCnum = $8B974		;d0 = SCnum of the goalie of the team of player d0
GetCreatedName = $96494
GetRosterName = $9649E		;a1 = name String of player d0 of team d7 (season roster aware)
GetJerseyNumber = $965A8		;jerseynum = the jersey number byte of player d0 of team d7
Rinktilelist = $C4A7C		;Rink map
HotList = $137B66		;Hot spot x / y bytes by frame
SmallFontMap2 = $139E02
ClockDigitsBitmap = $13FC18
EnergyBarMap = $14C4C8
BigFontMap3 = $15CE68
BigFontMap = $15E18A
BigFontMap2 = $15F46C
EASNmap = $180B4E
CrowdFrameList = $18B628
logoANH = $19A992		;TeamLogoBitmaps row
logoBOS = $19AE28		;TeamLogoBitmaps row
logoBUF = $19B17E		;TeamLogoBitmaps row
logoCGY = $19B4D4		;TeamLogoBitmaps row
logoCHI = $19B96A		;TeamLogoBitmaps row
logoDET = $19BDA0		;TeamLogoBitmaps row
logoEDM = $19C0F6		;TeamLogoBitmaps row
logoFLA = $19C4EC		;TeamLogoBitmaps row
logoHFD = $19C8A2		;TeamLogoBitmaps row
logoNYI = $19CB38		;TeamLogoBitmaps row
logoLA = $19CF8E		;TeamLogoBitmaps row
logoDAL = $19D304		;TeamLogoBitmaps row
logoMTL = $19D71A		;TeamLogoBitmaps row
logoNJ = $19DA90		;TeamLogoBitmaps row
logoNYR = $19DF46		;TeamLogoBitmaps row
logoOTW = $19E41C		;TeamLogoBitmaps row
logoPHI = $19E832		;TeamLogoBitmaps row
logoPIT = $19EBE8		;TeamLogoBitmaps row
logoQUE = $19EF5E		;TeamLogoBitmaps row
logoSJ = $19F2B4		;TeamLogoBitmaps row
logoSTL = $19F6EA		;TeamLogoBitmaps row
logoTB = $19FAC0		;TeamLogoBitmaps row
logoTOR = $19FED6		;TeamLogoBitmaps row
logoVAN = $1A022C		;TeamLogoBitmaps row
logoWSH = $1A0642		;TeamLogoBitmaps row
logoWPG = $1A08B8		;TeamLogoBitmaps row
logoASE = $1A0D2E		;TeamLogoBitmaps row
logoASW = $1A11E4		;TeamLogoBitmaps row
TeamLogoPalettes = $1A169A
ArenaGfxBank = $1A1A1A		;dc.l x+(TeamGfxList rows)

; Main segment code
	include	engine\middle95.asm
