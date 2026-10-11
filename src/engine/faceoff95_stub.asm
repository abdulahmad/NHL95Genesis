	include	macros\genesis.mac	;String (main95.asm includes it in the full build)
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
;	faceoff95 segment stub. Retail $08827C-$088F05.
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; region code
	org	$8827C

; includes for stubs to replace removed code
	include	stubinc\ports.inc	;IO_* / VDP_* ports
	include	stubinc\equals.inc	;VDP status bits
	include	ram95.asm		;RAM map

; External addresses outside $08827C-$088F05, read from lst/nhl95.bin.
TeamList = $772		;teamdata95
SprSort = $A8E6		;display95
sfx = $677AC		;sound95
song = $678C2		;sound95
ChooseSong = $679C4		;sound95
dobitmap = $79A3C		;video95
DoDMA_clearCallbackPointer = $79AC0		;video95
forceblack = $7A02A		;video95
Framer = $7A270		;video95
vtoa = $7C586		;middle95
randomd0 = $7C63A		;middle95
printz2 = $7C6D4		;middle95
printz = $7C810		;middle95
eraser = $7C8CC		;middle95
PrintSmallListItem = $7CB38		;middle95
ClrHor = $7D4E2		;middle95
AssignPads = $7D540		;middle95
PrintScores1 = $7D776		;middle95
WeightedRandomSelect = $7DC0A		;middle95
assexit = $8155E		;logic95
assinsert = $81570		;logic95
assreplace = $8157A		;logic95
ReturnGoalies = $8362E		;logic95
SetPersonel = $836CC		;players95
forcepldata = $83880		;players95
ResetBench = $83D5E		;players95
resetplstuff = $83DC2		;players95
GetShifter = $876FC		;setup95
LeadSong = $88F70		;penalty95
Stop4Pen = $8901C		;penalty95
linelist = $8A02C		;penalty95
SetLCmode = $8A056		;penalty95
SetLCmode2 = $8A094		;lines95
lcfound = $8A2CA		;lines95
CompLine = $8A3FE		;lines95
dirtab = $8B9D6		;skate95
SetSPA = $8BC9A		;skate95
checkwindow = $8C900		;goal95
SetGoaliesCtl = $8CA38		;goal95
PeriodOver = $8CB5A		;goal95
clockcont_0 = $8CBC2		;goal95
FaceOffMap = $149E32		;graphics95
FaceOffSprites = $14A490		;graphics95
RefTiles = $14EB04		;graphics95

; Main segment code
	include	engine\faceoff95.asm
