;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
;	hockey95_02 segment stub. Retail $07E36C-$07E4D5.
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; region code
	org	$7E36C

; includes for stubs to replace removed code
	include	stubinc\ports.inc	;IO_* / VDP_* ports
	include	stubinc\equals.inc	;VDP status bits
	include	ram95.asm		;RAM map

; External addresses outside $07E36C-$07E4D5, read from lst/nhl95.bin.
setvideo = $A204		;display95_01
Z80Program = $BD86		;The 95 Z80 sound program (sounddrv95)
SoundBanks = $D8EC		;The sound bank (sounddrv95)
SoundCmd = $676D8		;sound95_01
play_new_song = $67938		;sound95_01
KillCrowd = $67988		;sound95_01
SoundOff = $679B2		;sound95_01
forceblack = $7A02A		;video95_02
ReadMenuJoy = $7A6AA		;video95_02
ProcessInputWithRepeat = $7A762	;collide95_01
vcountwait = $7C6BE		;video95_03
AnyPadAssigned = $7DFAC		;fourway95
seta2 = $7E4D6			;menu95
InitMenuState = $7E526		;menu95
HandleMenuInput = $7E560	;menu95
SetPauseMenuItems = $7E6CA	;95: menulist / menuitemoffset by game mode (menu95)
PauseScreenDraw = $7E816	;The pause screen draw code (menu95)
RestoreGameScreen = $7EBBE	;Rebuild the game screen after the pause (menu95)
PracticeGoalies = $8CADE	;checks95_06

; Main segment code
	include	hockey95_02.asm
