	include	macros\genesis.mac	;String (main95.asm includes it in the full build)
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
;	middle95 segment stub. Retail $07C512-$07DFAB.
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; region code
	org	$7C512

; includes for stubs to replace removed code
	include	stubinc\ports.inc	;IO_* / VDP_* ports
	include	stubinc\equals.inc	;VDP status bits
	include	ram95.asm		;RAM map

; External addresses outside $07C512-$07DFAB, read from lst/nhl95.bin.
ZeroLong = $69A		;main95
TeamList = $772		;teamdata95
ReadSRAM = $9952		;sram95
defaultsprites = $A656		;display95
SprSort = $A8E6		;display95
chgplayer = $AB4E		;control95
setc1player = $AD80		;control95
setc2player = $AD8A		;control95
setc3player = $AD96		;control95
setc4player = $ADA2		;control95
setplayercolors = $AF1A		;control95
SoundCmd = $676D8		;sound95
DoFill = $79902		;video95
setvram = $79936		;video95
Vmaddr = $79A22		;video95
dobitmap = $79A3C		;video95
DoDMA_clearCallbackPointer = $79AC0		;video95
WaitDMA = $79B12		;video95
xyVmMap = $79C18		;video95
DoDMAlist = $79CA8		;video95
rtss2 = $79CC8		;asstab entry 0, the shared rts (video95)
addframe2 = $79DA8		;video95
AddSmallFont = $7A256		;video95
Framer = $7A270		;video95
AddFramer = $7A2EC		;video95
AddFramer2 = $7A310		;video95
VBlank = $7A332		;video95
ReadJoy1 = $7A4B0		;video95
ReadJoy2 = $7A4C8		;video95
ReadJoy3 = $7A4E0		;video95
ReadJoy4 = $7A50C		;video95
StickHandTable = $83C9E		;CalcAttrib, attribute 5 (stick handling) scale (players95)
PAttribOverallMask = $85846		;setup95
GAttribOverallMask = $859A8		;setup95
getGoalieSCnum = $8B974		;95: d0 = SCnum of the goalie of the team of player d0
GetCreatedName = $96494		;create95
GetRosterName = $9649E		;a1 = name String of player d0 of team d7 (season roster aware)
GetJerseyNumber = $965A8		;jerseynum = the jersey number byte of player d0 of team d7
Rinktilelist = $C4A7C		;Rink map (graphics95)
Hotlist = $137B66		;Hot spot x / y bytes by frame (GetHot; graphics95)
SmallFontMap2 = $139E02		;graphics95
ClockDigitsBitmap = $13FC18		;graphics95
EnergyBarMap = $14C4C8		;graphics95
BigFontMap3 = $15CE68		;graphics95
BigFontMap = $15E18A		;graphics95
BigFontMap2 = $15F46C		;graphics95
EASNmap = $180B4E		;graphics95
CrowdFrameList = $18B628		;graphics95
logoANH = $19A992		;TeamLogoBitmaps row (graphics95)
logoBOS = $19AE28		;TeamLogoBitmaps row (graphics95)
logoBUF = $19B17E		;TeamLogoBitmaps row (graphics95)
logoCGY = $19B4D4		;TeamLogoBitmaps row (graphics95)
logoCHI = $19B96A		;TeamLogoBitmaps row (graphics95)
logoDET = $19BDA0		;TeamLogoBitmaps row (graphics95)
logoEDM = $19C0F6		;TeamLogoBitmaps row (graphics95)
logoFLA = $19C4EC		;TeamLogoBitmaps row (graphics95)
logoHFD = $19C8A2		;TeamLogoBitmaps row (graphics95)
logoNYI = $19CB38		;TeamLogoBitmaps row (graphics95)
logoLA = $19CF8E		;TeamLogoBitmaps row (graphics95)
logoDAL = $19D304		;TeamLogoBitmaps row (graphics95)
logoMTL = $19D71A		;TeamLogoBitmaps row (graphics95)
logoNJ = $19DA90		;TeamLogoBitmaps row (graphics95)
logoNYR = $19DF46		;TeamLogoBitmaps row (graphics95)
logoOTW = $19E41C		;TeamLogoBitmaps row (graphics95)
logoPHI = $19E832		;TeamLogoBitmaps row (graphics95)
logoPIT = $19EBE8		;TeamLogoBitmaps row (graphics95)
logoQUE = $19EF5E		;TeamLogoBitmaps row (graphics95)
logoSJ = $19F2B4		;TeamLogoBitmaps row (graphics95)
logoSTL = $19F6EA		;TeamLogoBitmaps row (graphics95)
logoTB = $19FAC0		;TeamLogoBitmaps row (graphics95)
logoTOR = $19FED6		;TeamLogoBitmaps row (graphics95)
logoVAN = $1A022C		;TeamLogoBitmaps row (graphics95)
logoWSH = $1A0642		;TeamLogoBitmaps row (graphics95)
logoWPG = $1A08B8		;TeamLogoBitmaps row (graphics95)
logoASE = $1A0D2E		;TeamLogoBitmaps row (graphics95)
logoASW = $1A11E4		;TeamLogoBitmaps row (graphics95)
TeamLogoPalettes = $1A169A		;graphics95
ArenaGfxBank = $1A1A1A		;dc.l x+(TeamGfxList rows; arena95)

; Main segment code
	include	engine\middle95.asm
