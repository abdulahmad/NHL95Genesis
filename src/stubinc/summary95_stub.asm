;	Segment build for summary95.asm: sets its origin and the outside routines and data it uses,
;	then includes summary95.asm on its own for checking against the ROM.

	include	macros\genesis.mac		;String
; region code
	org	$A0D1A

; includes for stubs to replace removed code
	include	stubinc\ports.inc		;IO_* / VDP_* ports
	include	stubinc\equals.inc		;VDP status bits
	include	ram95.asm				;RAM map

; External addresses outside, read from lst/nhl95.bin.
ReadMenuJoy = $7A6AA
vcountwait = $7C6BE
printsmallz = $7C6D4
printsmall = $7C6E6
printz = $7C810
print = $7C822
eraser = $7C8CC
PrintSmallListItem = $7CB38
FormatPlayerNumInitial = $7CD38
PushNumber = $7D120
PutTeamBlock = $7D268
printbigz = $7D8D2
FormatAndPrintTime = $7DF7C
ExitStatsScreen = $8546E
Penaltylist = $89C2E
DrawTeamScreen2 = $8ACEC
ControllerBgMap = $164AC8

; Main segment code
	include	front\summary95.asm
