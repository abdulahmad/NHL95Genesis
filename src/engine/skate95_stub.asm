	include	macros\genesis.mac	;String (main95.asm includes it in the full build)
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
;	skate95 segment stub. Retail $08B4E0-$08C303.
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; region code
	org	$8B4E0

; includes for stubs to replace removed code
	include	stubinc\ports.inc	;IO_* / VDP_* ports
	include	stubinc\equals.inc	;VDP status bits
	include	ram95.asm		;RAM map

; External addresses outside $08B4E0-$08C303, read from lst/nhl95.bin.
SPAlist = $5A34		;frames95
sfx = $677AC		;sound95
sroot = $7C512		;middle95
vtoa = $7C586		;middle95
getpde = $7CAD0		;middle95
setpde = $7DBCA		;middle95
AdjustFacingDirection = $80426		;logic95
goaliesave = $80478		;logic95

; Main segment code
	include	engine\skate95.asm
