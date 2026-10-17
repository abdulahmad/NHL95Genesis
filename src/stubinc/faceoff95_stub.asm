;	Segment build for faceoff95.asm: sets its origin and the outside routines and data it uses,
;	then includes faceoff95.asm on its own for checking against the ROM.

	include	macros\genesis.mac		;String
; region code
	org	$8827C

; includes for stubs to replace removed code
	include	stubinc\ports.inc		;IO_* / VDP_* ports
	include	stubinc\equals.inc		;VDP status bits
	include	ram95.asm				;RAM map

; External addresses outside, read from lst/nhl95.bin.
TeamList = $772
SprSort = $A8E6
sfx = $677AC
song = $678C2
ChooseSong = $679C4
dobitmap = $79A3C
DecompressGraphicsPlain = $79AC0
forceblack = $7A02A
Framer = $7A270
vtoa = $7C586
randomd0 = $7C63A
printsmallz = $7C6D4
printz = $7C810
eraser = $7C8CC
PrintSmallListItem = $7CB38
ClrHor = $7D4E2
AssignPads = $7D540
printscores1 = $7D776
WeightedRandomSelect = $7DC0A
assexit = $8155E
assinsert = $81570
assreplace = $8157A
ReturnGoalies = $8362E
setpersonel = $836CC
forcepldata = $83880
ResetBench = $83D5E
resetplstuff = $83DC2
GetShifter = $876FC
LeadSong = $88F70
Stop4Pen = $8901C
linelist = $8A02C
SetLCmode = $8A056
SetLCmode2 = $8A094
lcfound = $8A2CA
CompLine = $8A3FE
dirtab = $8B9D6
SetSPA = $8BC9A
SPAglide = $B5C
SPAfaceoff = $1B36
SPAfaceoffr = $1B60
SPFpuck = $1B3
checkwindow = $8C900
PullPracticePlayers = $8CA38
PeriodOver = $8CB5A
clockcont_0 = $8CBC2
FaceOffMap = $149E32
FaceOffSprites = $14A490
RefTiles = $14EB04

; Main segment code
	include	engine\faceoff95.asm
