;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
;	stats95_02 segment stub. Retail $0A0B3E-$0A12A9.
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; region code
	org	$A0B3E

; includes for stubs to replace removed code
	include	stubinc\ports.inc	;IO_* / VDP_* ports
	include	stubinc\equals.inc	;VDP status bits
	include	stubinc\ram_addrs.inc	;RAM names

; External addresses outside $0A0B3E-$0A12A9, read from lst/nhl95.bin.
ReadMenuJoy = $7A6AA		;video95_02
vcountwait = $7C6BE		;video95_03
printz2 = $7C6D4		;video95_03
printsmall = $7C6E6		;video95_03
printz = $7C810			;video95_03
print = $7C822			;video95_03
eraser = $7C8CC			;video95_03
PrintSmallListItem = $7CB38	;video95_03
FormatPlayerNameWithAttrib = $7CD38	;video95_03
PushNumber = $7D120		;video95_03
PutTeamBlock = $7D268		;video95_03
printbigz = $7D8D2		;video95_03
FormatAndPrintTime = $7DF7C	;fourway95
ExitAttributeScreen2 = $8546E	;data95_01
PenaltyNames = $89C2E		;data95_02
DrawTeamScreen2 = $8ACEC	;checks95_05
ControllerBgMap = $164AC8	;graphics95_01
CrowdFrameList = $18B628		;graphics95_01

; Main segment code
	include	stats95_02.asm
