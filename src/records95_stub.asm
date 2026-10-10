;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
;	records95 segment stub. Retail $09B6F4-$09C019.
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; region code
	org	$9B6F4

; includes for stubs to replace removed code
	include	stubinc\ports.inc	;IO_* / VDP_* ports
	include	stubinc\equals.inc	;VDP status bits
	include	stubinc\ram_addrs.inc	;RAM names

; External addresses outside $09B6F4-$09C019, read from lst/nhl95.bin.
WriteSRAM = $98E6		;sram95
MakeSRAMChecksum = $9908	;sram95
ReadSRAM = $9952		;sram95
ReadMenuJoy = $7A6AA		;video95_02
ProcessInputWithRepeat = $7A762	;video95_02
vcountwait = $7C6BE		;video95_03
printz2 = $7C6D4		;video95_03
printsmall = $7C6E6		;video95_03
printz = $7C810			;video95_03
eraser = $7C8CC			;video95_03
PushNumberWidth = $7D154	;video95_03
appstring = $7D214		;video95_03
printbigz = $7D8D2		;video95_03
AppendTeamName = $7DC36		;video95_03
StartText = $7DC62		;video95_03
AppendUserName = $7DC76		;video95_03
ExitAttributeScreen2 = $8546E	;data95_01
ReadTeamStats = $877AC		;data95_01
DisplayAttributeScreen = $925B2	;stats95_01
NameEntryScreen = $9ACE6	;cards95_01
SetupScreen = $9C5B8		;cards95_02

; Main segment code
	include	records95.asm
