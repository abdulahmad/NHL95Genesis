	include	macros\genesis.mac	;String (main95.asm includes it in the full build)
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
;	penalty95 segment stub. Retail $088F06-$08996D.
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; region code
	org	$88F06

; includes for stubs to replace removed code
	include	stubinc\ports.inc	;IO_* / VDP_* ports
	include	stubinc\equals.inc	;VDP status bits
	include	stubinc\ram_addrs.inc	;RAM names

; External addresses outside $088F06-$08996D, read from lst/nhl95.bin.
sfx = $677AC			;sound95_01
song = $678C2			;sound95_01
play_new_song = $67938		;sound95_01
ChooseSong = $679C4		;sound95_01
DoDMA_clearCallbackPointer = $79AC0	;video95_01
Framer = $7A270			;video95_02
printz = $7C810			;video95_03
print = $7C822			;video95_03
eraser = $7C8CC			;video95_03
GetPeriodTimeRemaining = $7D762	;video95_03
Setplass = $81540		;checks95_02
assinsert = $81570		;checks95_02
assreplace = $8157A		;checks95_02
setplayer = $83960		;collide95_02
priolist = $83E16		;collide95_02
PenaltyNames = $89C2E		;data95_02
chkatop = $8AB7E		;checks95_05
updatePPTeamTime = $8ABB4	;checks95_05
DisplayPlayerAttributeMenu = $8C6B0	;checks95_06
DisplayPeriodOver = $95B1E	;stats95_01
ShootoutWonBy = $9DFE6		;shootout95
PenaltyShotBox = $9EDD2		;checks95_07
RefTiles = $14EB04		;graphics95_01
RefTilesHor = $14FBA2		;graphics95_01

; Main segment code
	include	penalty95.asm
