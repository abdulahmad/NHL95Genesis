;	The game engine. This list includes the engine files in ROM order. They assemble as one piece
;	because branches cross from file to file, and the old Z80 program sits among them.

	include	engine\video95.asm		; VDP helpers, DMA, palettes, sprite frames, rink scroll, the decompressor, vblank, pads
	include	engine\collide95.asm		; checks, falls, wall, puck and goal collisions
	include	engine\middle95.asm		; math, text, names, numbers, clock digits, team blocks, team graphics
	include	engine\fourway95.asm		; four-player adaptor
	include	sound\z80old95.asm		; the 94 Z80 program, unused
	include	engine\pause95.asm		; Pausemode, the 95 pause menu and its items
	include	engine\logic95.asm		; the player AI: assignments, puck handling, skateto, one-timers, goalie AI
	include	engine\players95.asm		; SetPersonel, SetPlList, player attributes, the bench, hot / cold
	include	engine\input95.asm		; doinput: passes, one-timers and shots
	include	engine\setup95.asm		; team roster screen, the game setup screen, playoff structures, line data
	include	engine\playoff95.asm		; PlayoffScreen, the playoff tree
	include	engine\faceoff95.asm		; the scoreboard after a goal, faceoffs
	include	engine\penalty95.asm		; penalties, the referee, Penaltylist, icing and offsides
	include	engine\lines95.asm		; line changes, computer lines, saved lines, team line screens
	include	engine\skate95.asm		; goalie and skater movement
	include	engine\goal95.asm		; the goal, period and game over, the clock, the controller setup screen
	include	engine\replay95.asm		; instant replay
