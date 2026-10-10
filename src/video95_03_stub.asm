	include	macros\genesis.mac	;String (main95.asm includes it in the full build)
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
;	video95_03 segment stub. Retail $07C512-$07DE9F.
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; region code
	org	$7C512

; includes for stubs to replace removed code
	include	stubinc\ports.inc	;IO_* / VDP_* ports
	include	stubinc\equals.inc	;VDP status bits
	include	stubinc\ram_addrs.inc	;RAM names

; External addresses outside $07C512-$07DE9F, read from lst/nhl95.bin.
TeamList = $772			;teamdata95
defaultsprites = $A656		;setup95_01
SprSort = $A8E6			;setup95_01
chgplayer = $AB4E		;setup95_01
setc1player = $AD80		;setup95_01
setc2player = $AD8A		;setup95_01
setc3player = $AD96		;setup95_01
setc4player = $ADA2		;setup95_01
setplayercolors = $AF1A		;setup95_01
ReadSRAM = $9952		;sram95
SoundCmd = $676D8		;sound95_01
DoFill = $79902			;video95_01
setvram = $79936		;video95_01
Vmaddr = $79A22			;video95_01
dobitmap = $79A3C		;video95_01
DoDMA_clearCallbackPointer = $79AC0	;video95_01
WaitDMA = $79B12		;video95_01
xyVmMap = $79C18		;video95_01
DoDMAlist = $79CA8		;video95_01
rtss2 = $79CC8			;An rts (video95_01)
addframe2 = $79DA8		;display95_02
AddSmallFont = $7A256		;video95_02
Framer = $7A270			;video95_02
AddFramer = $7A2EC		;video95_02
AddFramer2 = $7A310		;video95_02
VBlank = $7A332			;video95_02
ReadJoy1 = $7A4B0		;video95_02
ReadJoy2 = $7A4C8		;video95_02
ReadJoy3 = $7A4E0		;video95_02
ReadJoy4 = $7A50C		;video95_02
LoadHomeTeamGfx = $7DEA0	;fourway95
EASNLogo = $7DF32		;fourway95
setupEASNmap = $7DF6A		;fourway95
StickHandTable = $83C9E	;CalcAttrib, attribute 5 (stick handling) scale (collide95_02)
PAttribOverallMask = $85846	;data95_01
GAttribOverallMask = $859A8	;data95_01
FindGoalie = $8B974		;95: d0 = SCnum of the goalie of the team of player d0
GetCreatedName = $96494		;create95
GetRosterName = $9649E		;a1 = name String of player d0 of team d7 (season roster aware)
GetJerseyNumber = $965A8	;jerseynum = the jersey number byte of player d0 of team d7
Rinktilelist = $C4A7C		;graphics95_01
SmallFontMap2 = $139E02		;graphics95_01
HotSpotList = $137B66		;Hot spot x / y bytes by frame (GetHot; graphics95_01)
ClockDigitsBitmap = $13FC18	;Big clock digits (PutClockDigit; graphics95_01)
EnergyBarMap = $14C4C8		;graphics95_01
BigFontMap3 = $15CE68		;graphics95_01
BigFontMap = $15E18A		;graphics95_01
BigFontMap2 = $15F46C		;graphics95_01
CrowdFrameList = $18B628	;graphics95_01
TeamLogoPalettes = $1A169A	;#(graphics95_01)
logoANA = $19A992		;TeamLogoBitmaps row (graphics95_01)
logoBOS = $19AE28		;TeamLogoBitmaps row (graphics95_01)
logoBUF = $19B17E		;TeamLogoBitmaps row (graphics95_01)
logoCGY = $19B4D4		;TeamLogoBitmaps row (graphics95_01)
logoCHI = $19B96A		;TeamLogoBitmaps row (graphics95_01)
logoDAL = $19D304		;TeamLogoBitmaps row (graphics95_01)
logoDET = $19BDA0		;TeamLogoBitmaps row (graphics95_01)
logoEDM = $19C0F6		;TeamLogoBitmaps row (graphics95_01)
logoFLA = $19C4EC		;TeamLogoBitmaps row (graphics95_01)
logoHFD = $19C8A2		;TeamLogoBitmaps row (graphics95_01)
logoLA = $19CF8E		;TeamLogoBitmaps row (graphics95_01)
logoMTL = $19D71A		;TeamLogoBitmaps row (graphics95_01)
logoNJ = $19DA90		;TeamLogoBitmaps row (graphics95_01)
logoNYI = $19CB38		;TeamLogoBitmaps row (graphics95_01)
logoNYR = $19DF46		;TeamLogoBitmaps row (graphics95_01)
logoOTW = $19E41C		;TeamLogoBitmaps row (graphics95_01)
logoPHI = $19E832		;TeamLogoBitmaps row (graphics95_01)
logoPIT = $19EBE8		;TeamLogoBitmaps row (graphics95_01)
logoQUE = $19EF5E		;TeamLogoBitmaps row (graphics95_01)
logoSJ = $19F2B4		;TeamLogoBitmaps row (graphics95_01)
logoSTL = $19F6EA		;TeamLogoBitmaps row (graphics95_01)
logoTB = $19FAC0		;TeamLogoBitmaps row (graphics95_01)
logoTOR = $19FED6		;TeamLogoBitmaps row (graphics95_01)
logoVAN = $1A022C		;TeamLogoBitmaps row (graphics95_01)
logoWSH = $1A0642		;TeamLogoBitmaps row (graphics95_01)
logoWPG = $1A08B8		;TeamLogoBitmaps row (graphics95_01)
logoASE = $1A0D2E		;TeamLogoBitmaps row (graphics95_01)
logoASW = $1A11E4		;TeamLogoBitmaps row (graphics95_01)

; Main segment code
	include	video95_03.asm
