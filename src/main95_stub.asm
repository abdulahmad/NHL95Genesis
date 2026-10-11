;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
;	main95 segment stub. Retail $000000-$000771.
;	main95.asm includes macros\genesis.mac itself (it is the first file in nhl95.asm), so this stub does not.
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; region code
	org	0

; includes for stubs to replace removed code
	include	stubinc\ports.inc	;IO_* / VDP_* ports
	include	stubinc\equals.inc	;VDP status bits
	include	ram95.asm		;RAM map

; External addresses outside $000000-$000771, read from lst/nhl95.bin.
; The vector longs carry the address itself; jsr / jmp (x).l carry it too; movea.l #x carries it as the immediate.
IRQ7 = $7A416			;(an rte) Vectors $60-$70 and $7C (video95)
VBjsr = $7A32C			;Vector $78 (video95)
ValidationRoutine = $1A72C0	;checksum95
SoundCmd = $676D8		;sound95
SoundOff = $679B2		;sound95
KillCrowd = $67988		;sound95
Detect4WayPlay = $7DFC6		;fourway95
EASportsScreen = $8AAC8		;lines95
InitSaveRAM = $9722		;sram95
HiScoreScreen = $A16DE		;title95
ReadLineData = $87B30		;setup95
DefaultMenus = $866DE		;setup95
orjoy = $7A448			;video95
Opening = $9AC8			;hockey95
Z80Program = $BD86		;The 95 Z80 sound program (sound95)
SoundBanks = $D8EC		;The sound data after the Z80 program (sound95)

; Main segment code
	include	main95.asm
