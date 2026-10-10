;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
;	shootout95 segment stub. Retail $09DD3E-$09E5EF.
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; region code
	org	$9DD3E

; includes for stubs to replace removed code
	include	stubinc\ports.inc	;IO_* / VDP_* ports
	include	stubinc\equals.inc	;VDP status bits
	include	ram95.asm		;RAM map

; External addresses outside $09DD3E-$09E5EF, read from lst/nhl95.bin.
TeamList = $772			;main95
Framer = $7A270			;video95_02
ReadMenuJoy = $7A6AA		;video95_02
ProcessInputWithRepeat = $7A762	;video95_02
vcountwait = $7C6BE		;video95_03
printz2 = $7C6D4		;video95_03
printsmall = $7C6E6		;video95_03
printz = $7C810			;video95_03
print = $7C822			;video95_03
eraser = $7C8CC			;video95_03
ReadAttributeNibble = $7CB4E	;video95_03
getname = $7CC90		;video95_03
FormatPlayerNameWithAttrib = $7CD38	;video95_03
FormatPlayerNameShort = $7CE16	;video95_03
PushNumberWidth = $7D154	;video95_03
PutTeamBlock = $7D268		;video95_03
printbigz = $7D8D2		;video95_03
printbigz1 = $7D8F6		;video95_03
printbig1 = $7D908		;video95_03
assinsert = $81570		;checks95_02
GetPlayerCount = $838F2		;collide95_02
setplayer = $83960		;collide95_02
ExitAttributeScreen2 = $8546E	;data95_01
getNameandAttrib = $8547A	;data95_01
PAttribOverall = $85834		;data95_01
GAttribOverall = $85996		;data95_01
prefmes = $89898		;penalty95
DrawTeamScreen6 = $8B32A	;checks95_05
LockScroll = $8C8EC		;checks95_06
ExitToOpening = $8CD02		;checks95_06
LineEditorBg = $95998		;stats95_01
PlayerSelectBg = $959E4		;stats95_01
StartShootoutPath = $9DB0A	;title95_01
PlayerSelectMap1 = $16FA70	;graphics95_01

; Main segment code
	include	shootout95.asm
