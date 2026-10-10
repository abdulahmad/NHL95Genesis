;
;	Top level of the full NHL 95 ROM build (build95.bat, npm run build:retail). The listing is output\nhl95 .lst.
;	The includes are in ROM order; the address on each line is where the file starts in lst/nhl95.bin. The names follow
;	NHL94Genesis (<file>94.asm -> <file>95.asm). A 94 file that 95 splits into pieces separated by other files is numbered
;	<file>95_01, _02, ... in ROM order. Pure data files (tables, text, graphics, palettes) are in data\.
;	The org for a segment build goes in its _stub.asm. Do not put an org in a file this list includes: this file sets org 0.
;	ram95.asm (the RAM map), stubinc\ports.inc and stubinc\equals.inc are equates only, so they come first.
;
	include	stubinc\ports.inc	;IO_* / VDP_* ports. Equates only
	include	stubinc\equals.inc	;VDP status bits. Equates only
	include	ram95.asm		;RAM map. Equates only

	org	0			;the ROM starts at 0. Without an org SNASM writes a short, misaligned bin (the stubs carry their own org)
	include	main95.asm		; $000000  vectors, cartridge header, SegaInit, the 95 region lock, Begin (main94)
	include	data\teamdata95.asm		; $000772  team data: TeamList and one block per team (teamdata94)
	include	data\frames95.asm		; $005A34  sprite animation tables and revframetbl (frames94)
	include	data\schedule95.asm		; $008DD8  95 only: the season schedule
	include	sram95.asm		; $009722  battery save RAM: init, read / write, checksum, leader list builders (sram94)
	include	hockey95_01.asm		; $009AC8  game flow: Opening, the main menu exits, StartGame, StartPer, Gameloop (hockey94)
	include	display95_01.asm		; $00A204  setvideo, checksso, setsortcords, uppads (display94)
	include	replay95_01.asm		; $00A536  updateanim (replay94)
	include	setup95_01.asm		; $00A656  defaultsprites, holdplayer / burst, chgplayer, InitTeamSructure (setup94, input94)
	include	sounddrv95.asm		; $00AF44  95 only: the sound driver, the Z80 program and the sound bank
	include	sound95_01.asm		; $0676D8  sound calls, the unused 94 driver, the 94 samples and FM patches (sound94)
	include	video95_01.asm		; $079902  VDP helpers, DMA, palettes, the vblank sprite and scroll dumps (middle94, display94)
	include	display95_02.asm		; $079D80  addframe, addframe2, sizetab, updatescroll (display94)
	include	video95_02.asm		; $07A02A  forceblack, the graphics decompressor (video94)
	include	collide95_01.asm		; $07A762  puck, player, wall and goal collisions, fights (collide94)
	include	video95_03.asm		; $07C512  math, text and name formatting helpers (video94 and others)
	include	fourway95.asm		; $07DEA0  home team graphics, EASN logo, clock text, four-player adaptor (fourway94 and others)
	include	data\sound95_02.asm		; $07E0E0  the 94 Z80 program, unused (sound94)
	include	hockey95_02.asm		; $07E36C  Pausemode, SetupPauseScreen (hockey94)
	include	menu95.asm		; $07E4D6  the 95 pause menu (menu94)
	include	checks95_01.asm		; $07F97E  pause menu items, then checks94 from assgoaliecpu (checks94)
	include	assign95_01.asm		; $0807EC  defense assignments: assdefd, asswingd (assign94)
	include	checks95_02.asm		; $080BEA  offense assignments, puck handling, skateto (checks94, assign94)
	include	assign95_02.asm		; $08282E  assbench, asspenalty, assdopen, assepen (assign94)
	include	onetimer95.asm		; $082BD0  one-timers (onetimer94)
	include	checks95_03.asm		; $082FC2  assshoot, the goalie assignments, ChkGoalies (checks94, assign94)
	include	collide95_02.asm		; $0836AC  SetPersonel, SetPlList, player attributes, the bench, hot / cold (collide94 and others)
	include	input95_01.asm		; $083EB2  doinput: passes, one-timers and shots (input94)
	include	data95_01.asm		; $084FE6  team roster screen, the game setup screen, playoff structures, line data (data94 and others)
	include	setup95_02.asm		; $087BA2  PlayoffScreen (setup94)
	include	checks95_04.asm		; $088046  faceoffs, the playoff tree (checks94)
	include	penalty95.asm		; $088F06  penalties, the referee, the scoreboard messages (penalty94)
	include	data95_02.asm		; $08996E  PenaltyList, penalty and offsides checks (data94 and others)
	include	input95_02.asm		; $08A056  line changes (input94)
	include	checks95_05.asm		; $08A3FE  computer line changes, goalie dive, shot stats, saved lines, team screens (checks94)
	include	input95_03.asm		; $08B734  doinput_cbut, ClampTargetY, doinput_chkanim (input94)
	include	checks95_06.asm		; $08B9A8  player movement, SetSPA, the goal, the controller setup screen (checks94)
	include	replay95_02.asm		; $08D39A  instant replay (replay94)
	include	season95.asm		; $08DF5A  95 only: season mode
	include	period95.asm		; $0920DE  game statistics screen (period94)
	include	stats95_01.asm		; $0925AE  player stats, the 95 season stats, League Leaders, line editor, Stars of the Game (stats94)
	include	trade95.asm		; $0962EE  95 only: season rosters and trades
	include	create95.asm		; $097C54  95 only: Create Player, Sign Free Agents, Release Players
	include	cards95_01.asm		; $09ACE6  name entry (cards94)
	include	records95.asm		; $09B6F4  user name entry and records (records94)
	include	cards95_02.asm		; $09C01A  user records after a game, the setup screen (cards94)
	include	awards95.asm		; $09C6F0  95 only: end of season awards
	include	title95_01.asm		; $09DA50  shootout setup and paths (title94)
	include	shootout95.asm		; $09DD3E  shootout (shootout94)
	include	checks95_07.asm		; $09E5F0  shootout and penalty shot play, injuries, power play box (checks94)
	include	scout95.asm		; $09F590  matchups and scouting report (scout94)
	include	setup95_03.asm		; $0A00D6  scouting text, hot / cold lists (setup94)
	include	stats95_02.asm		; $0A0B3E  scoring and penalty summaries (stats94)
	include	title95_02.asm		; $0A12AA  title screen, credits, high scores (title94)
	include	data\graphics95_01.asm		; $0A1A5A  graphics: player pictures, rink, sprites, fonts, screen maps (graphics94)
	include	data\title95_03.asm		; $1A169A  team logo palettes (title94)
	include	data\graphics95_02.asm		; $1A1A1A  ArenaGfxBank, the home team graphics (graphics94)
	include	data\credits95.asm		; $1A6C28  title screen credits text (teamdata94)
	include	checksum95.asm		; $1A72C0  ValidationRoutine (checksum94)
	dcb.b	$200000-*,$FF		;fill to the 2 MB ROM end
