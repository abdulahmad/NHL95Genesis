;	Segment build for penalty95.asm: sets its origin and the outside routines and data it uses,
;	then includes penalty95.asm on its own for checking against the ROM.

	include	macros\genesis.mac	;String
; region code
limitfo = $88F06
	org	$88F70

; includes for stubs to replace removed code
	include	stubinc\ports.inc	;IO_* / VDP_* ports
	include	stubinc\equals.inc	;VDP status bits
	include	ram95.asm		;RAM map

; External addresses outside, read from lst/nhl95.bin.
sfx = $677AC
song = $678C2
stop_current_song = $67938
ChooseSong = $679C4
DecompressGraphicsPlain = $79AC0
Framer = $7A270
randomd0 = $7C63A
printz = $7C810
print = $7C822
eraser = $7C8CC
GetPeriodTimeRemaining = $7D762
Setplass = $81540
assinsert = $81570
assreplace = $8157A
setplayer = $83960
priolist = $83E16
chkatop = $8AB7E
updatePPTeamTime = $8ABB4
ShowGoalBox = $8C6B0
ShowThreeStars = $95B1E
ShootoutWonBy = $9DFE6
PenaltyShotBox = $9EDD2
RefTiles = $14EB04
RefTilesHor = $14FBA2

; Main segment code
	include	engine\penalty95.asm
