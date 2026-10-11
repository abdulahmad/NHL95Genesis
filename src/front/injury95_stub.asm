	include	macros\genesis.mac	;String (main95.asm includes it in the full build)
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
;	injury95 segment stub. Retail $09F012-$09F58F.
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; region code
	org	$9F012

; includes for stubs to replace removed code
	include	stubinc\ports.inc	;IO_* / VDP_* ports
	include	stubinc\equals.inc	;VDP status bits
	include	ram95.asm		;RAM map

; External addresses outside $09F012-$09F58F, read from lst/nhl95.bin.
MakeSRAMChecksum = $9908		;sram95
sfx = $677AC		;sound95
Framer = $7A270		;video95
randomd0 = $7C63A		;middle95
printz = $7C810		;middle95
print = $7C822		;middle95
GetTempPlayerNameAttrib = $7CCD2		;middle95
PushTime = $7D0BC		;middle95
PushNumberWidth = $7D154		;middle95
appendz = $7D20C		;middle95
appstring = $7D214		;middle95
EASNLogo = $7DF32		;middle95

; Main segment code
	include	front\injury95.asm
