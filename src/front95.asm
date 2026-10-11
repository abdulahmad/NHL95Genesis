;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
;	The menus and screens around the game.
;	The files of front\ in ROM order, included by nhl95.asm. No org: nhl95.asm sets org 0.
;	Each file has its own stub next to it (front\<file>_stub.asm) to build and verify it alone.
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

	include	front\season95.asm		; $08DF5A  season mode
	include	front\stats95.asm		; $0920DE  game, player and season stats, League Leaders, line editor, highlights
	include	front\trade95.asm		; $0962EE  season rosters and trades
	include	front\create95.asm		; $097C54  Create Player, Sign Free Agents, Release Players
	include	front\records95.asm		; $09ACE6  name entry, user names, record holders, record updates
	include	front\awards95.asm		; $09C6F0  end of season awards
	include	front\shootout95.asm		; $09DA50  the shootout and the penalty shot
	include	front\injury95.asm		; $09F012  injuries, the power play box
	include	front\scout95.asm		; $09F590  matchups, scouting report and its text, hot / cold lists
	include	front\crowd95.asm		; $0A0B3E  the crowd meter
	include	front\summary95.asm		; $0A0D1A  scoring and penalty summaries
	include	front\title95.asm		; $0A12AA  title screen, credits, high scores, Stanley Cup
