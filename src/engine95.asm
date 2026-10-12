;	The game engine: includes the files of engine\ in ROM order (one assembly, since
;	PC-relative branches cross every file in it), plus the old Z80 program (the Z80OldProgram
;	macro of sound95.asm) that sits among them.

	include	engine\video95.asm		; $079902  VDP helpers, DMA, palettes, sprite frames, rink scroll, the decompressor, vblank, pads
	include	engine\collide95.asm		; $07A7B4  checks, falls, wall, puck and goal collisions
	include	engine\middle95.asm		; $07C512  math, text, names, numbers, clock digits, team blocks, team graphics
	include	engine\fourway95.asm		; $07DFAC  four-player adaptor
	Z80OldProgram			; $07E0E0  the 94 Z80 program, unused (macro in sound95.asm)
	include	engine\pause95.asm		; $07E36C  Pausemode, the 95 pause menu and its items
	include	engine\logic95.asm		; $07FCFC  the player AI: assignments, puck handling, skateto, one-timers, goalie AI
	include	engine\players95.asm		; $0836AC  SetPersonel, SetPlList, player attributes, the bench, hot / cold
	include	engine\input95.asm		; $083EB2  doinput: passes, one-timers and shots
	include	engine\setup95.asm		; $084FE6  team roster screen, the game setup screen, playoff structures, line data
	include	engine\playoff95.asm		; $087BA2  PlayoffScreen, the playoff tree
	include	engine\faceoff95.asm		; $08827C  the scoreboard after a goal, faceoffs
	include	engine\penalty95.asm		; $088F06  penalties, the referee, Penaltylist, icing and offsides
	include	engine\lines95.asm		; $08A056  line changes, computer lines, saved lines, team line screens
	include	engine\skate95.asm		; $08B4E0  goalie and skater movement
	include	engine\goal95.asm		; $08C304  the goal, period and game over, the clock, the controller setup screen
	include	engine\replay95.asm		; $08D39A  instant replay
