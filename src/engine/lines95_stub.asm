	include	macros\genesis.mac	;String (main95.asm includes it in the full build)
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
;	lines95 segment stub. Retail $08A056-$08B4DF.
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; region code
	org	$8A056

; includes for stubs to replace removed code
	include	stubinc\ports.inc	;IO_* / VDP_* ports
	include	stubinc\equals.inc	;VDP status bits
	include	ram95.asm		;RAM map

; External addresses outside $08A056-$08B4DF, read from lst/nhl95.bin.
ZeroLong = $69A		;main95
TeamList = $772		;teamdata95
WriteSRAM = $98E6		;sram95
MakeSRAMChecksum = $9908		;sram95
ReadSRAM = $9952		;sram95
setVram_0 = $7994C		;video95
Vmaddr = $79A22		;video95
dobitmap = $79A3C		;video95
DoDMA_clearCallbackPointer = $79AC0		;video95
CopyPaletteToCRAM = $79BE2		;video95
SetScroll2 = $79CCA		;video95
forceblack = $7A02A		;video95
DecompressGraphicsWithCallback = $7A264		;video95
Framer = $7A270		;video95
vb2 = $7A3F6		;video95
printz = $7C810		;middle95
print = $7C822		;middle95
eraser = $7C8CC		;middle95
loadTeamStruct = $7CAF0		;middle95
PrintSmallListItem = $7CB38		;middle95
ReadAttributeNibbleD7 = $7CB60		;middle95
GetDefenseStartD7 = $7CBB6		;middle95
setupTeamBlocksMap = $7D2AE		;middle95
waitx = $7D706		;middle95
printscores1 = $7D776		;middle95
reenergizeteam = $7DBA2		;middle95
setpersonel = $836CC		;players95
GetPlayerCountD7 = $83904		;players95
ResetBench = $83D5E		;players95
priolist = $83E16		;players95
compshoot = $84FB6		;input95
linelist = $8A02C		;penalty95
doplayeracc = $8BCFA		;skate95
box = $8C694		;goal95
GetRosterName = $9649E		;a1 = name String of player d0 of team d7 (season roster aware)
TeamRecordSRAM = $96A34		;trade95
RosterFont = $1383C6		;graphics95
SmallFontMap = $139094		;graphics95
Teamblocksmap = $142906		;graphics95
Framermap = $14C148		;graphics95
EnergyBarMap = $14C4C8		;graphics95
EASportsMap = $14C796		;graphics95
BigFontMap2 = $15F46C		;graphics95
Screen6Tiles1 = $16EABC		;graphics95
Screen6Tiles2 = $16F7DA		;graphics95

; Main segment code
	include	engine\lines95.asm
