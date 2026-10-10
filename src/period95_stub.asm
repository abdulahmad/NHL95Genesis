;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
;	period95 segment stub. Retail $0920DE-$0925AD.
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; region code
	org	$920DE

; includes for stubs to replace removed code
	include	stubinc\ports.inc	;IO_* / VDP_* ports
	include	stubinc\equals.inc	;VDP status bits
	include	stubinc\ram_addrs.inc	;RAM names

; External addresses outside $0920DE-$0925AD, read from lst/nhl95.bin.
nodiag = $7A488			;video95_02
ReadMenuJoy = $7A6AA		;video95_02
vcountwait = $7C6BE		;video95_03
printz2 = $7C6D4		;video95_03
printz = $7C810			;video95_03
print = $7C822			;video95_03
PushTime = $7D0BC		;video95_03
PushNumber = $7D120		;video95_03
appendz = $7D20C		;video95_03
appstring = $7D214		;video95_03
PutTeamBlock = $7D268		;video95_03
printbigz = $7D8D2		;video95_03
ExitAttributeScreen2 = $8546E	;data95_01
DrawTeamScreen2 = $8ACEC	;checks95_05
rtsStatTables = $925AE		;stats95_01
ControllerBgMap = $164AC8	;graphics95_01

; Main segment code
	include	period95.asm
