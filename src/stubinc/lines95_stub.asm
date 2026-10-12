;	Segment build for lines95.asm: sets its origin and the outside routines and data it uses,
;	then includes lines95.asm on its own for checking against the ROM.

	include	macros\genesis.mac	;String
; region code
	org	$8A02C

; includes for stubs to replace removed code
	include	stubinc\ports.inc	;IO_* / VDP_* ports
	include	stubinc\equals.inc	;VDP status bits
	include	ram95.asm		;RAM map

; External addresses outside, read from lst/nhl95.bin.
ZeroLong = $69A
TeamList = $772
WriteSRAM = $98E6
MakeSRAMChecksum = $9908
ReadSRAM = $9952
setVram_0 = $7994C
Vmaddr = $79A22
dobitmap = $79A3C
DecompressGraphicsPlain = $79AC0
CopyPaletteToCRAM = $79BE2
SetScroll2 = $79CCA
forceblack = $7A02A
DecompressGraphicsWithCallback = $7A264
Framer = $7A270
vb2 = $7A3F6
printz = $7C810
print = $7C822
eraser = $7C8CC
loadTeamStruct = $7CAF0
PrintSmallListItem = $7CB38
GetGoalieCountD7 = $7CB60
GetDefenseStartD7 = $7CBB6
setupTeamBlocksMap = $7D2AE
waitx = $7D706
printscores1 = $7D776
reenergizeteam = $7DBA2
setpersonel = $836CC
GetPlayerCountD7 = $83904
ResetBench = $83D5E
priolist = $83E16
CompShoot = $84FB6
doplayeracc = $8BCFA
box = $8C694
GetRosterName = $9649E		;a1 = name String of player d0 of team d7 (season roster aware)
TeamRecordSRAM = $96A34
RosterFont = $1383C6
SmallFontMap = $139094
Teamblocksmap = $142906
Framermap = $14C148
EnergyBarMap = $14C4C8
EASportsMap = $14C796
BigFontMap2 = $15F46C
Screen6Tiles1 = $16EABC
Screen6Tiles2 = $16F7DA

; Main segment code
	include	engine\lines95.asm
