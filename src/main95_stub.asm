;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
;	Segment stub.
;	includes macros\genesis.mac itself (it is the first file in nhl95.asm), so this stub does not.
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; region code
	org	0

; includes for stubs to replace removed code
	include	stubinc\ports.inc	;IO_* / VDP_* ports
	include	stubinc\equals.inc	;VDP status bits
	include	ram95.asm		;RAM map

; External addresses outside, read from lst/nhl95.bin.
; The vector longs carry the address itself; jsr / jmp (x).l carry it too; movea.l #x carries it as the immediate.
IRQ7 = $7A416			;(an rte) Vectors $60-$70 and $7C
VBjsr = $7A32C			;Vector $78
ValidationRoutine = $1A72C0
SoundCmd = $676D8
SoundOff = $679B2
KillCrowd = $67988
Detect4WayPlay = $7DFC6
EASportsScreen = $8AAC8
InitSaveRAM = $9722
HiScoreScreen = $A16DE
ReadLineData = $87B30
DefaultMenus = $866DE
orjoy = $7A448
Opening = $9AC8
Z80Program = $BD86		;The 95 Z80 sound program
SoundBanks = $D8EC		;The sound data after the Z80 program

; Main segment code
	include	main95.asm
