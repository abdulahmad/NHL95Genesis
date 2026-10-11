	include	macros\genesis.mac	;String (main95.asm includes it in the full build)
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
;	summary95 segment stub. Retail $0A0D1A-$0A12A9.
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; region code
	org	$A0D1A

; includes for stubs to replace removed code
	include	stubinc\ports.inc	;IO_* / VDP_* ports
	include	stubinc\equals.inc	;VDP status bits
	include	ram95.asm		;RAM map

; External addresses outside $0A0D1A-$0A12A9, read from lst/nhl95.bin.
ReadMenuJoy = $7A6AA		;video95
vcountwait = $7C6BE		;middle95
printz2 = $7C6D4		;middle95
printsmall = $7C6E6		;middle95
printz = $7C810		;middle95
print = $7C822		;middle95
eraser = $7C8CC		;middle95
PrintSmallListItem = $7CB38		;middle95
FormatPlayerNameWithAttrib = $7CD38		;middle95
PushNumber = $7D120		;middle95
PutTeamBlock = $7D268		;middle95
printbigz = $7D8D2		;middle95
FormatAndPrintTime = $7DF7C		;middle95
ExitAttributeScreen2 = $8546E		;setup95
PenaltyList = $89C2E		;penalty95
DrawTeamScreen2 = $8ACEC		;lines95
ControllerBgMap = $164AC8		;graphics95

; Main segment code
	include	front\summary95.asm
