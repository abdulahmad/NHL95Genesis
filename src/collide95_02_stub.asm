;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
;	collide95_02 segment stub. Retail $0836AC-$083EB1.
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; region code
	org	$836AC

; includes for stubs to replace removed code
	include	stubinc\ports.inc	;IO_* / VDP_* ports
	include	stubinc\equals.inc	;VDP status bits
	include	stubinc\ram_addrs.inc	;RAM names

; External addresses outside $0836AC-$083EB1, read from lst/nhl95.bin.
TeamList = $772			;main95
ReadSRAM = $9952		;sram95
randomd0s = $7C62E		;video95_03
GetPeriodTime = $7D4CA		;video95_03
chkpk2 = $7D894			;video95_03
Setplass = $81540		;checks95_02
assinsert = $81570		;checks95_02
SetSPA = $8BC9A			;checks95_06
GetRosterName = $9649E		;trade95
GetJerseyNumber = $965A8	;trade95
SetSeasonInjuries = $9F144	;95 only: mark the season injuries (tmpdst -4) of team a2 from save RAM (checks95_07)

; Main segment code
	include	collide95_02.asm
