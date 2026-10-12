;	Team, sprite frame and schedule data: includes the files of tables\ in ROM order.

	include	tables\teamdata95.asm		; $000772  team data: TeamList and one block per team
	include	tables\frames95.asm		; $005A34  sprite animation tables and revframetbl
	include	tables\schedule95.asm		; $008DD8  the season schedule
