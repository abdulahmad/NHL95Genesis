	include	macros\genesis.mac	;String (main95.asm includes it in the full build)
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
;	control95 segment stub. Retail $00A95C-$00AF43.
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; region code
	org	$A95C

; includes for stubs to replace removed code
	include	stubinc\ports.inc	;IO_* / VDP_* ports
	include	stubinc\equals.inc	;VDP status bits
	include	ram95.asm		;RAM map

; External addresses outside $00A95C-$00AF43, read from lst/nhl95.bin.
SPAskate = $2		;main95
SPAskatewp = $738		;main95
TeamList = $772		;teamdata95
SPAHold = $E10		;teamdata95
SPAhook = $E74		;teamdata95
SPAburst = $11AE		;teamdata95
ReadJoy1 = $7A4B0		;video95
ReadJoy2 = $7A4C8		;video95
ReadJoy3 = $7A4E0		;video95
ReadJoy4 = $7A50C		;video95
checkcoll = $7A7B4		;collide95
Sweepcheck = $7B08A		;collide95
getpde = $7CAD0		;middle95
setpde = $7DBCA		;middle95
doassignment = $7FD84		;95 only: run a3's assignment (94 updateplayers does the asstab call in line). (logic95)
doinput = $83EB2		;players95
LoadTeamLines = $8A622		;lines95
dirtab = $8B9D6		;skate95
SetSPA = $8BC9A		;skate95
chkblock = $8D39A		;95 only: may change d1 to SPAblock. (replay95)

; Main segment code
	include	control95.asm
