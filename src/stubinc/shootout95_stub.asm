;	Segment build for shootout95.asm: sets its origin and the outside routines and data it uses,
;	then includes shootout95.asm on its own for checking against the ROM.

	include	macros\genesis.mac	;String
; region code
	org	$9DA50

; includes for stubs to replace removed code
	include	stubinc\ports.inc	;IO_* / VDP_* ports
	include	stubinc\equals.inc	;VDP status bits
	include	ram95.asm		;RAM map

; External addresses outside, read from lst/nhl95.bin.
TeamList = $772
SprSort = $A8E6
setc1player = $AD80
setc2player = $AD8A
song = $678C2
ChooseSong = $679C4
DecompressGraphicsPlain = $79AC0
forceblack = $7A02A
Framer = $7A270
ReadMenuJoy = $7A6AA
ProcessInputWithRepeat = $7A762
vtoa = $7C586
randomd0 = $7C63A
vcountwait = $7C6BE
printsmallz = $7C6D4
printsmall = $7C6E6
printz = $7C810
print = $7C822
eraser = $7C8CC
GetGoalieCount = $7CB4E
getname = $7CC90
FormatPlayerNumInitial = $7CD38
FormatPlayerNameShort = $7CE16
PushNumberWidth = $7D154
PutTeamBlock = $7D268
AssignPads = $7D540
printbigz = $7D8D2
printbigz1 = $7D8F6
printbig1 = $7D908
RestoreGameScreen = $7EBBE
Setplass = $81540
assinsert = $81570
assreplace = $8157A
ReturnGoalies = $8362E
setpersonel = $836CC
GetPlayerCount = $838F2
setplayer = $83960
ResetBench = $83D5E
resetplstuff = $83DC2
ExitStatsScreen = $8546E
GetNameandAttrib = $8547A
PAttribOverall = $85834
GAttribOverall = $85996
Stop4Pen = $8901C
AddPenalty2 = $8916E
prefmes = $89898
Penaltylist = $89C2E
PenShotPenalties = $89FFC
DrawTeamScreen6 = $8B32A
getGoalieSCnum = $8B974		;d0 = SCnum of the goalie of the team of player d0
SetSPA = $8BC9A
SPAglide = $B5C
SPFpuck = $1B3
LockScroll = $8C8EC
checkwindow = $8C900
ExitToOpening = $8CD02
LineEditorBg = $95998
PlayerSelectBg = $959E4
RefTiles = $14EB04
PlayerSelectMap1 = $16FA70

; Main segment code
	include	front\shootout95.asm
