;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
;	Team, sprite frame and schedule data.
;	The files of tables\ in ROM order, included by nhl95.asm. No org: nhl95.asm sets org 0.
;	Each file has its own stub next to it (tables\<file>_stub.asm) to build and verify it alone.
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

	include	tables\teamdata95.asm		; $000772  team data: TeamList and one block per team
	include	tables\frames95.asm		; $005A34  sprite animation tables and revframetbl
	include	tables\schedule95.asm		; $008DD8  the season schedule
