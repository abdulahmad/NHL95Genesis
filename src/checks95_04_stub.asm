	include	macros\genesis.mac	;String (main95.asm includes it in the full build)
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
;	checks95_04 segment stub. Retail $088046-$088F05.
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; region code
	org	$88046

; includes for stubs to replace removed code
	include	stubinc\ports.inc	;IO_* / VDP_* ports
	include	stubinc\equals.inc	;VDP status bits
	include	ram95.asm		;RAM map

; External addresses outside $088046-$088F05, read from lst/nhl95.bin.
TeamList = $772			;teamdata95
SprSort = $A8E6			;setup95_01
sfx = $677AC			;sound95_01
song = $678C2			;sound95_01
ChooseSong = $679C4		;sound95_01
dobitmap = $79A3C		;video95_01
DoDMA_clearCallbackPointer = $79AC0	;video95_01
forceblack = $7A02A		;display95_02
Framer = $7A270			;video95_02
vtoa = $7C586			;video95_03
randomd0 = $7C63A		;video95_03
printz2 = $7C6D4		;video95_03
printz = $7C810			;video95_03
eraser = $7C8CC			;video95_03
PrintSmallListItem = $7CB38	;video95_03
ClrHor = $7D4E2			;video95_03
AssignPads = $7D540		;video95_03
PrintScores1 = $7D776		;video95_03
WeightedRandomSelect = $7DC0A	;video95_03
assexit = $8155E		;checks95_02
assinsert = $81570		;checks95_02
assreplace = $8157A		;checks95_02
ReturnGoalies = $8362E		;checks95_03
SetPersonel = $836CC		;collide95_02
forcepldata = $83880		;collide95_02
ResetBench = $83D5E		;collide95_02
resetplstuff = $83DC2		;collide95_02
GetShifter = $876FC		;data95_01
LeadSong = $88F70		;penalty95
Stop4Pen = $8901C		;penalty95
linelist = $8A02C		;data95_02
SetLCmode = $8A056		;data95_02
SetLCmode2 = $8A094		;input95_02
lcfound = $8A2CA		;input95_02
CompLine = $8A3FE		;input95_02
dirtab = $8B9D6			;checks95_06
SetSPA = $8BC9A			;checks95_06
checkwindow = $8C900		;checks95_06
SetGoaliesCtl = $8CA38		;checks95_06
PeriodOver = $8CB5A		;checks95_06
clockcont_0 = $8CBC2		;checks95_06
FaceOffMap = $149E32		;graphics95_01
FaceOffSprites = $14A490	;graphics95_01
RefTiles = $14EB04		;graphics95_01
PlayoffSprite = $1842DA		;graphics95_01

; Main segment code
	include	checks95_04.asm
