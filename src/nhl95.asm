;
;	Top level of the full NHL 95 ROM build. The listing is output\nhl95 .lst.
;	The includes are in ROM order; the address on each line is where the file (or the first file of a list) starts in
;	lst/nhl95.bin. One file per subsystem (hockey, main, teamdata, frames, ram, video, middle, logic, penalty, sound,
;	checksum, graphics). The tables\, engine\ and front\ lists give their files in ROM order. A file lives in the
;	folder of its subsystem but is included where its bytes are (sound\z80old95.asm is in the engine list).
;	docs/FILE_ORIGINS.md gives the origin of every routine.
;	The org for a segment build goes in its _stub.asm, next to the file. Do not put an org in a file these lists include: this
;	file sets org 0.
;	(the RAM map), stubinc\ports.inc and stubinc\equals.inc are equates only, so they come first.
;
	include	stubinc\ports.inc	;IO_* / VDP_* ports. Equates only
	include	stubinc\equals.inc	;VDP status bits. Equates only
	include	ram95.asm		;RAM map. Equates only

	org	0			;the ROM starts at 0. Without an org SNASM writes a short, misaligned bin (the stubs carry their own org)
	include	main95.asm		; $000000  vectors, cartridge header, SegaInit, the 95 region lock, Begin
	include	tables95.asm		; $000772: team, sprite frame and schedule data
	include	sram95.asm		; $009722  battery save RAM: init, read / write, checksum, leader list builders
	include	hockey95.asm		; $009AC8  game flow: Opening, the main menu exits, StartGame, StartPer, Gameloop
	include	display95.asm		; $00A204  setvideo, sort coordinates, pads, updateanim, default sprites, SprSort
	include	control95.asm		; $00A95C  which pad controls which player, team setup
	include	sound\sound95.asm		; $00AF44  the 95 sound driver, its Z80 program and sound bank, the sound calls, the unused 94 driver and samples
	include	engine95.asm		; $079902: the game engine (one assembly: PC-relative branches cross every file in it)
	include	front95.asm		; $08DF5A: the menus and screens around the game
	include	graphics95.asm		; $0A1A5A  player pictures, rink, sprites, fonts, screen maps, logo palettes, arena graphics
	include	credits95.asm		; $1A6C28  title screen credits text
	include	checksum95.asm		; $1A72C0  ValidationRoutine
	dcb.b	$200000-*,$FF		;fill to the 2 MB ROM end
