	include	macros\genesis.mac	;String (main95.asm includes it in the full build)
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
;	penalty95 segment stub. Retail $088F06-$08A055.
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; region code
	org	$88F06

; includes for stubs to replace removed code
	include	stubinc\ports.inc	;IO_* / VDP_* ports
	include	stubinc\equals.inc	;VDP status bits
	include	ram95.asm		;RAM map

; External addresses outside $088F06-$08A055, read from lst/nhl95.bin.
sfx = $677AC		;sound95
song = $678C2		;sound95
play_new_song = $67938		;sound95
ChooseSong = $679C4		;sound95
DoDMA_clearCallbackPointer = $79AC0		;video95
Framer = $7A270		;video95
randomd0 = $7C63A		;middle95
printz = $7C810		;middle95
print = $7C822		;middle95
eraser = $7C8CC		;middle95
GetPeriodTimeRemaining = $7D762		;middle95
Setplass = $81540		;logic95
assinsert = $81570		;logic95
assreplace = $8157A		;logic95
setplayer = $83960		;players95
priolist = $83E16		;players95
chkatop = $8AB7E		;lines95
updatePPTeamTime = $8ABB4		;lines95
DisplayPlayerAttributeMenu = $8C6B0		;goal95
DisplayPeriodOver = $95B1E		;stats95
ShootoutWonBy = $9DFE6		;shootout95
PenaltyShotBox = $9EDD2		;shootout95
RefTiles = $14EB04		;graphics95
RefTilesHor = $14FBA2		;graphics95

; Main segment code
	include	engine\penalty95.asm
