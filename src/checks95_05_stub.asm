	include	macros\genesis.mac	;String (main95.asm includes it in the full build)
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
;	checks95_05 segment stub. Retail $08A3FE-$08B733.
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; region code
	org	$8A3FE

; includes for stubs to replace removed code
	include	stubinc\ports.inc	;IO_* / VDP_* ports
	include	stubinc\equals.inc	;VDP status bits
	include	stubinc\ram_addrs.inc	;RAM names

; External addresses outside $08A3FE-$08B733, read from lst/nhl95.bin.
TeamList = $772			;teamdata95
WriteSRAM = $98E6		;sram95
MakeSRAMChecksum = $9908	;sram95
ReadSRAM = $9952		;sram95
setVram_0 = $7994C		;video95_01
Vmaddr = $79A22			;video95_01
dobitmap = $79A3C		;video95_01
DoDMA_clearCallbackPointer = $79AC0	;video95_01
CopyPaletteToCRAM = $79BE2	;video95_01
SetScroll2 = $79CCA		;video95_01
forceblack = $7A02A		;display95_02
DecompressGraphicsWithCallback = $7A264	;video95_02
vb2 = $7A3F6			;video95_02
vtoa = $7C586			;video95_03
printz = $7C810			;video95_03
eraser = $7C8CC			;video95_03
loadTeamStruct = $7CAF0		;video95_03
ReadAttributeNibbleD7 = $7CB60	;video95_03
GetDefenseStartD7 = $7CBB6	;video95_03
setupTeamBlocksMap = $7D2AE	;video95_03
waitx = $7D706			;video95_03
PrintScores1 = $7D776		;video95_03
ResetTeamEnergy = $7DBA2	;video95_03
AdjustFacingDirection = $80426	;checks95_01
SetPersonel = $836CC		;collide95_02
GetPlayerCountD7 = $83904	;collide95_02
ResetBench = $83D5E		;collide95_02
compshoot = $84FB6		;input95_01
rtslc = $8A330			;input95_02
getlinee = $8A382		;input95_02
AvgCline = $8A3C4		;input95_02
doinput_cbut = $8B734		;checks95_05
GoalieReadySPA = $8B9A8		;input95_03
stopna = $8BB1A			;checks95_06
SetSPA = $8BC9A			;checks95_06
stopna2 = $8BCB0		;checks95_06
playeracc = $8C086		;checks95_06
GetRosterName = $9649E		;trade95
TeamRecordSRAM = $96A34		;trade95
RosterFont = $1383C6		;graphics95_01
SmallFontMap = $139094		;graphics95_01
Teamblocksmap = $142906		;graphics95_01
Framermap = $14C148		;graphics95_01
EASportsMap = $14C796		;graphics95_01
BigFontMap2 = $15F46C		;graphics95_01
Screen6Tiles1 = $16EABC		;graphics95_01
Screen6Tiles2 = $16F7DA		;graphics95_01

; Main segment code
	include	checks95_05.asm
