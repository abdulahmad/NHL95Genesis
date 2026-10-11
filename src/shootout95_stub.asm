;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
;	shootout95 segment stub. Retail $09DA50-$09E5EF.
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; region code
	org	$9DA50

; includes for stubs to replace removed code
	include	stubinc\ports.inc	;IO_* / VDP_* ports
	include	stubinc\equals.inc	;VDP status bits
	include	ram95.asm		;RAM map

; External addresses outside $09DA50-$09E5EF:
randomd0 = $7C63A		;video95_02
TeamList = $772			;main95
Framer = $7A270			;video95_01
ReadMenuJoy = $7A6AA		;video95_01
ProcessInputWithRepeat = $7A762	;video95_01
vcountwait = $7C6BE		;video95_02
printz2 = $7C6D4		;video95_02
printsmall = $7C6E6		;video95_02
printz = $7C810			;video95_02
print = $7C822			;video95_02
eraser = $7C8CC			;video95_02
ReadAttributeNibble = $7CB4E	;video95_02
getname = $7CC90		;video95_02
FormatPlayerNameWithAttrib = $7CD38	;video95_02
FormatPlayerNameShort = $7CE16	;video95_02
PushNumberWidth = $7D154	;video95_02
PutTeamBlock = $7D268		;video95_02
printbigz = $7D8D2		;video95_02
printbigz1 = $7D8F6		;video95_02
printbig1 = $7D908		;video95_02
assinsert = $81570		;checks95_01
GetPlayerCount = $838F2		;collide95_02
setplayer = $83960		;collide95_02
ExitAttributeScreen2 = $8546E	;optsetup95
getNameandAttrib = $8547A	;optsetup95
PAttribOverall = $85834		;optsetup95
GAttribOverall = $85996		;optsetup95
prefmes = $89898		;penalty95
DrawTeamScreen6 = $8B32A	;checks95_04
LockScroll = $8C8EC		;checks95_04
ExitToOpening = $8CD02		;checks95_04
LineEditorBg = $95998		;stats95_01
PlayerSelectBg = $959E4		;stats95_01
PlayerSelectMap1 = $16FA70	;graphics95_01

; Main segment code
	include	shootout95.asm
