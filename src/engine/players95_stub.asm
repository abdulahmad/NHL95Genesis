;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
;	Segment stub.
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; region code
	org	$836AC

; includes for stubs to replace removed code
	include	stubinc\ports.inc	;IO_* / VDP_* ports
	include	stubinc\equals.inc	;VDP status bits
	include	ram95.asm		;RAM map

; External addresses outside, read from lst/nhl95.bin.
TeamList = $772
ReadSRAM = $9952
randomd0s = $7C62E
GetPeriodTime = $7D4CA
chkpk2 = $7D894
Setplass = $81540
assinsert = $81570
SetSPA = $8BC9A
GetRosterName = $9649E
GetJerseyNumber = $965A8
SetSeasonInjuries = $9F144	;mark the season injuries (tmpdst -4) of team a2 from save RAM

; Main segment code
	include	engine\players95.asm
