	include	macros\genesis.mac	;String (main95.asm includes it in the full build)

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
;	checks95_04 segment stub. Retail $08A3FE-$08D399.
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; region code
	org	$8A3FE

; includes for stubs to replace removed code
	include	stubinc\ports.inc	;IO_* / VDP_* ports
	include	stubinc\equals.inc	;VDP status bits
	include	ram95.asm		;RAM map

; External addresses outside $08A3FE-$08D399:
ZeroLong = $69A			;main95
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
forceblack = $7A02A		;video95_01
DecompressGraphicsWithCallback = $7A264	;video95_01
vb2 = $7A3F6			;video95_01
vtoa = $7C586			;video95_02
printz = $7C810			;video95_02
eraser = $7C8CC			;video95_02
loadTeamStruct = $7CAF0		;video95_02
ReadAttributeNibbleD7 = $7CB60	;video95_02
GetDefenseStartD7 = $7CBB6	;video95_02
setupTeamBlocksMap = $7D2AE	;video95_02
waitx = $7D706			;video95_02
PrintScores1 = $7D776		;video95_02
ResetTeamEnergy = $7DBA2	;video95_02
AdjustFacingDirection = $80426	;checks95_01
SetPersonel = $836CC		;collide95_02
GetPlayerCountD7 = $83904	;collide95_02
ResetBench = $83D5E		;collide95_02
compshoot = $84FB6		;input95_01
rtslc = $8A330			;input95_02
getlinee = $8A382		;input95_02
AvgCline = $8A3C4		;input95_02
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
SPAlist = $5A34			;frames95
sroot = $7C512			;collide95_01
goaliesave = $80478		;checks95_01
Opening2 = $9ADA		;hockey95
IntermissionStart = $9D18	;hockey95
sfx = $677AC			;sound95_01
play_new_song = $67938		;sound95_01
ChooseSong = $679C4		;sound95_01
setvram = $79936		;video95_01
Framer = $7A270			;video95_01
VBlank_SetOptions = $7A418	;video95_01
orjoy = $7A448			;video95_01
nodiag = $7A488			;video95_01
ReadJoy1 = $7A4B0		;video95_01
ReadJoy2 = $7A4C8		;video95_01
ReadJoy3 = $7A4E0		;video95_01
ReadJoy4 = $7A50C		;video95_01
printz2 = $7C6D4		;video95_02
printsmall = $7C6E6		;video95_02
print = $7C822			;video95_02
getpde = $7CAD0			;video95_02
ReadAttributeNibble = $7CB4E	;video95_02
FormatPlayerName = $7CDC2	;video95_02
PushNumberWidth = $7D154	;video95_02
GetPeriodTimeRemaining = $7D762	;video95_02
printbigz = $7D8D2		;video95_02
printbig1 = $7D908		;video95_02
setpde = $7DBCA			;video95_02
assinsert = $81570		;checks95_01
assreplace = $8157A		;checks95_01
EndOneTimer = $82F60		;onetimer95
EncodePW = $8756E		;optsetup95
AddPenalty2 = $8916E		;penalty95
RemovePlayerFromList = $8962C	;penalty95
ClearPenaltyBuffer = $89A7C	;data95
ClearPenalties = $89A8A		;data95
lcfound2 = $8A2FC		;input95_02
SeasonGameOver = $8EF2A		;season95
CountGoalies = $9C564		;cards95_02
EndPenaltyShotPlay = $9ECE6		;checks95_05
StanleyCupScreen = $A17B8	;title95_01
ControllerBgMap = $164AC8	;graphics95_01
ControllerTitleMap = $16AA7C	;graphics95_01
PadCursorMap = $16AD5A		;graphics95_01
PadIconMap1 = $16B0B2		;graphics95_01
PadIconMap2 = $16B1C8		;graphics95_01
PadIconMap3 = $16B2DE		;graphics95_01
PadIconMap4 = $16B3F4		;graphics95_01

; Main segment code
	include	checks95_04.asm
