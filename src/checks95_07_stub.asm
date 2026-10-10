;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
;	checks95_07 segment stub. Retail $09E5F0-$09F58F.
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; region code
	org	$9E5F0

; includes for stubs to replace removed code
	include	stubinc\ports.inc	;IO_* / VDP_* ports
	include	stubinc\equals.inc	;VDP status bits
	include	ram95.asm		;RAM map

; External addresses outside $09E5F0-$09F58F, read from lst/nhl95.bin.
MakeSRAMChecksum = $9908	;sram95
SprSort = $A8E6			;setup95_01
setc1player = $AD80		;setup95_01
setc2player = $AD8A		;setup95_01
sfx = $677AC			;sound95_01
song = $678C2			;sound95_01
ChooseSong = $679C4		;sound95_01
DoDMA_clearCallbackPointer = $79AC0	;video95_01
forceblack = $7A02A		;display95_02
Framer = $7A270			;video95_02
vtoa = $7C586			;video95_03
randomd0 = $7C63A		;video95_03
printz = $7C810			;video95_03
print = $7C822			;video95_03
GetTempPlayerNameAttrib = $7CCD2	;video95_03
FormatPlayerNameWithAttrib = $7CD38	;video95_03
PushTime = $7D0BC		;video95_03
PushNumberWidth = $7D154	;video95_03
appendz = $7D20C		;video95_03
appstring = $7D214		;video95_03
AssignPads = $7D540		;video95_03
printbig1 = $7D908		;video95_03
EASNLogo = $7DF32		;fourway95
RestoreGameScreen = $7EBBE	;menu95
Setplass = $81540		;checks95_02
assinsert = $81570		;checks95_02
assreplace = $8157A		;checks95_02
ReturnGoalies = $8362E		;checks95_03
SetPersonel = $836CC		;collide95_02
setplayer = $83960		;collide95_02
ResetBench = $83D5E		;collide95_02
resetplstuff = $83DC2		;collide95_02
Stop4Pen = $8901C		;penalty95
AddPenalty2 = $8916E		;penalty95
prefmes = $89898		;penalty95
PenaltyNames = $89C2E		;data95_02
PenShotPenalties = $89FFC	;data95_02
FindGoalie = $8B974		;input95_03
SetSPA = $8BC9A			;checks95_06
LockScroll = $8C8EC		;checks95_06
checkwindow = $8C900		;checks95_06
StartShootoutPath = $9DB0A	;title95_01
NextShooter = $9DD3E		;title95_01
CountShootoutGoals = $9DD94	;shootout95
PlayoffRoundScreen = $9DE8A	;shootout95
RefTiles = $14EB04		;graphics95_01

; Main segment code
	include	checks95_07.asm
