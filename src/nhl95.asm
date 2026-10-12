;	Top level of the ROM build. It includes the equates and then every module in ROM order, and
;	each file assembles right after the one before it. The engine and the front end each have a
;	list file of their own. Only this file sets the start address; a segment build sets its own
;	in its stub.

	include	stubinc\ports.inc	;IO_* / VDP_* ports. Equates only
	include	stubinc\equals.inc	;VDP status bits. Equates only
	include	ram95.asm		;RAM map. Equates only

	org	0			;the ROM starts at 0. Without an org SNASM writes a short, misaligned bin (the stubs carry their own org)
	include	main95.asm		; $000000  vectors, cartridge header, SegaInit, the 95 region lock, Begin
	include	teamdata95.asm		; $000772  team data: TeamList and one block per team
	include	frames95.asm		; $005A34  sprite animation tables and revframetbl
	include	schedule95.asm		; $008DD8  the season schedule
	include	sram95.asm		; $009722  battery save RAM: init, read / write, checksum, leader list builders
	include	hockey95.asm		; $009AC8  game flow: Opening, the main menu exits, StartGame, StartPer, Gameloop
	include	display95.asm		; $00A204  setvideo, sort coordinates, pads, updateanim, default sprites, SprSort
	include	control95.asm		; $00A95C  which pad controls which player, team setup
	include	sound95.asm			; $00AF44  the 95 sound driver, its Z80 program and sound bank, the sound calls, the unused 94 driver and samples
	include	engine95.asm		; $079902: the game engine (one assembly: PC-relative branches cross every file in it)
	include	front95.asm		; $08DF5A: the menus and screens around the game
	include	graphics95.asm		; $0A1A5A  player pictures, rink, sprites, fonts, screen maps, logo palettes, arena graphics
	include	credits95.asm		; $1A6C28  title screen credits text
	include	checksum95.asm		; $1A72C0  ValidationRoutine
	dcb.b	$200000-*,$FF		;fill to the 2 MB ROM end
