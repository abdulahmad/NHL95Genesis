	include	macros\genesis.mac	;String (main95.asm includes it in the full build)
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
;	shootout95 segment stub. Retail $09DA50-$09F011.
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; region code
	org	$9DA50

; includes for stubs to replace removed code
	include	stubinc\ports.inc	;IO_* / VDP_* ports
	include	stubinc\equals.inc	;VDP status bits
	include	ram95.asm		;RAM map

; External addresses outside $09DA50-$09F011, read from lst/nhl95.bin.
TeamList = $772		;teamdata95
SprSort = $A8E6		;display95
setc1player = $AD80		;control95
setc2player = $AD8A		;control95
song = $678C2		;sound95
ChooseSong = $679C4		;sound95
DoDMA_clearCallbackPointer = $79AC0		;video95
forceblack = $7A02A		;video95
Framer = $7A270		;video95
ReadMenuJoy = $7A6AA		;video95
ProcessInputWithRepeat = $7A762		;video95
vtoa = $7C586		;middle95
randomd0 = $7C63A		;middle95
vcountwait = $7C6BE		;middle95
printz2 = $7C6D4		;middle95
printsmall = $7C6E6		;middle95
printz = $7C810		;middle95
print = $7C822		;middle95
eraser = $7C8CC		;middle95
ReadAttributeNibble = $7CB4E		;middle95
getname = $7CC90		;middle95
FormatPlayerNameWithAttrib = $7CD38		;middle95
FormatPlayerNameShort = $7CE16		;middle95
PushNumberWidth = $7D154		;middle95
PutTeamBlock = $7D268		;middle95
AssignPads = $7D540		;middle95
printbigz = $7D8D2		;middle95
printbigz1 = $7D8F6		;middle95
printbig1 = $7D908		;middle95
RestoreGameScreen = $7EBBE		;pause95
Setplass = $81540		;logic95
assinsert = $81570		;logic95
assreplace = $8157A		;logic95
ReturnGoalies = $8362E		;logic95
SetPersonel = $836CC		;players95
GetPlayerCount = $838F2		;players95
setplayer = $83960		;players95
ResetBench = $83D5E		;players95
resetplstuff = $83DC2		;players95
ExitAttributeScreen2 = $8546E		;setup95
getNameandAttrib = $8547A		;setup95
PAttribOverall = $85834		;setup95
GAttribOverall = $85996		;setup95
Stop4Pen = $8901C		;penalty95
AddPenalty2 = $8916E		;penalty95
prefmes = $89898		;penalty95
PenaltyList = $89C2E		;penalty95
PenShotPenalties = $89FFC		;penalty95
DrawTeamScreen6 = $8B32A		;lines95
getGoalieSCnum = $8B974		;95: d0 = SCnum of the goalie of the team of player d0
SetSPA = $8BC9A		;skate95
LockScroll = $8C8EC		;goal95
checkwindow = $8C900		;goal95
ExitToOpening = $8CD02		;goal95
LineEditorBg = $95998		;stats95
PlayerSelectBg = $959E4		;stats95
RefTiles = $14EB04		;graphics95
PlayerSelectMap1 = $16FA70		;graphics95

; Main segment code
	include	front\shootout95.asm
