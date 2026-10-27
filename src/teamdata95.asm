;	*** ANONYMIZED: the player names and team nicknames are placeholders. ***
;	Players are P001 ... P662, nicknames N01 ... N26. The real ones are NHLPA / NHL licensed
;	data and are not in this repository.

;	Each Player row and each nickname String has a placeholder of the same length as the
;	real text (the Player macro writes the row length, so it must not change). The ratings
;	after a name are unchanged.

;	This file does not assemble into the real game by itself and is not included directly:
;	it needs the original ROM.

;	tools/extractAssets95.js reads the names from your ROM into Extracted/PlayerNames.txt
;	and Extracted/TeamNicknames.txt (one per line, in the order they appear below).

;	tools/prebuild.js (run by every build) copies this file to output/names/teamdata95.asm
;	with the real names put back, and nhl95.asm includes that copy.

;	Keep the placeholder lengths when editing a name or adding a player.
;
;	Team data. TeamList points to one record per team, the two All-Star teams included, and the
;	playoff seeds follow the teams.

TeamList							;Team number = index (ANH 0 ... WPG 25, ASE 26, ASW 27)
	dc.l	Anaheim					;0 ANH
	dc.l	Boston					;1 BOS
	dc.l	Buffalo					;2 BUF
	dc.l	Calgary					;3 CGY
	dc.l	Chicago					;4 CHI
	dc.l	Dallas					;5 DAL
	dc.l	Detroit					;6 DET
	dc.l	Edmonton				;7 EDM
	dc.l	Florida					;8 FLA
	dc.l	Hartford				;9 HFD
	dc.l	LosAngeles				;10 LA
	dc.l	Montreal				;11 MTL
	dc.l	NewJersey				;12 NJ
	dc.l	NewYorkI				;13 NYI
	dc.l	NewYorkR				;14 NYR
	dc.l	Ottawa					;15 OTW
	dc.l	Philadelphia			;16 PHI
	dc.l	Pittsburgh				;17 PIT
	dc.l	Quebec					;18 QUE
	dc.l	SanJose					;19 SJ
	dc.l	StLouis					;20 STL
	dc.l	TampaBay				;21 TB
	dc.l	Toronto					;22 TOR
	dc.l	Vancouver				;23 VAN
	dc.l	Washington				;24 WSH
	dc.l	Winnipeg				;25 WPG
	dc.l	AllStarsEast			;26 ASE
	dc.l	AllStarsWest			;27 ASW

NumofTeams	=	(*-TeamList)/4
	IF NumofTeams<>NumTeams
	inform 3,"TeamList does not match the team count"
	ENDIF
Playerdata	=	0
Palettedata	=	2
Teamname	=	4
LineSets	=	6
ScoutReport	=	8
GoalieOdds	=	10

;------------------------
; Team block: 6 offset words (the equates above), .pad home and visitor palettes (16 colours each, incbin
; <team> / <team> every 95 palette differs from 94), .sr (4 bytes of bonuses), .godds (starting goalie
; weights), .ls 8 lines of 8 player numbers (1 = first .pld entry), .pld players ended by an empty String,
; then 4 Strings: city, abbreviation, nickname, arena. Same layout as 94.
; Blocks are in ROM order (ASE and ASW first), not TeamList order. 94 put FLA and ANH last; 95 sorts them
; in by name, and Dallas sits between LA and MTL where 94 had Minnesota. WPG comes before WSH.
;------------------------
;------------------------
; .sr: 4 bytes, byte 3 is never read. byte 0: scoring odds of simulated games (SetScore): bits 4-6 = offense
; row, bits 0-2 = defense row of the weights table; byte 1: high nibble = penalty kill deficit, low nibble =
; power play bonus; byte 2: high nibble = home bonus, low nibble = visitor bonus (negated)
;q - scoring odds offense row (bits 4-6)
;r - scoring odds defense row (bits 0-2)
;e - penalty kill deficit
;b - power play bonus

;h - home bonus
;v - visitor bonus
;x - not read
;x - not read
; Player ratings (Player macro: name, then 16 nibbles unwl,sodp,chga,eytm)
;u - uniform # x10
;n - uniform # x1
;w - weight
;l - leg power
;s - speed
;o - offensive awareness
;d - defensive awareness
;p - shot power / NA for goalie
;c - checking strength / NA
;h - shooting hand / glove hand
;g - stickhandling / glove left saves
;a - shooting accuracy / glove right saves
;e - endurance / stick right saves
;y - shot/pass decision / stick left saves
;t - passing accuracy / consistency
;m - aggressiveness (PIM) / NA
;------------------------
AllStarsEast						;ASE, $7E2 (94 $37E)
.0
	dc.w	.pld-.0
	dc.w	.pad-.0
	dc.w	.tn-.0
	dc.w	.ls-.0
	dc.w	.sr-.0
	dc.w	.godds-.0
.pad
	incbin	..\Extracted\NHL95\Graphics\Pals\ASEh95.pal
	incbin	..\Extracted\NHL95\Graphics\Pals\ASEv95.pal
.sr
;		qreb,hvxx
	dc.w	$7720,$00E6
.godds
	dc.b	204,176
.ls									;8 lines of 8 player numbers
;		-G,LD,RD,LW,-C,RW,XA,00
	dc.b	01,21,18,07,05,17,04,00	;line 1 Sc1
	dc.b	01,21,18,12,10,15,04,00	;line 2 Sc2
	dc.b	01,19,23,14,04,17,05,00	;line 3 Chk
	dc.b	01,20,22,07,05,06,10,00	;line 4 PP1
	dc.b	01,21,22,16,08,11,12,00	;line 5 PP2
	dc.b	01,18,19,10,13,09,17,00	;line 6 PK1
	dc.b	01,20,23,12,15,16,11,00	;line 7 PK2
	dc.b	01,21,18,17,04,13,09,00	;line 8 8th line (94 addition, no linelist name)
.pld								;roster, ended by an empty String
;										unwl,sodp,chga,eytm
	Player	'P001_______',	3366,4355,0000,5666
	Player	'P002________',	3575,4344,0000,5555
	Player	'P003___________',	3454,3453,0000,4455
	Player	'P004________',	1195,4433,4993,4253
	Player	'P005______',	1275,4653,3A54,5061
	Player	'P006__________',	7794,4534,0995,4140
	Player	'P007_____',	1964,3543,29C5,5262
	Player	'P008_________',	1944,4434,2A64,4243
	Player	'P009_________',	1974,4414,1AC4,3242
	Player	'P010________',	88C4,3445,56A6,5344
	Player	'P011______',	0764,3433,3A65,4431
	Player	'P012_______',	0994,4433,5D73,4535
	Player	'P013___________',	0864,5434,2B64,4331
	Player	'P014_______',	0865,4534,3D95,4343
	Player	'P015________',	68A5,4534,4BC3,6152
	Player	'P016________',	2292,3434,2C64,3432
	Player	'P017____________',	8976,6634,1794,4451
	Player	'P018________',	0266,3544,2DC2,5252
	Player	'P019_________',	04B4,4464,5D73,5145
	Player	'P020________',	0373,3342,3BA1,3233
	Player	'P021_______',	77A5,4555,49C5,6452
	Player	'P022______',	43B4,4446,49A2,3344
	Player	'P023________',	55A4,3554,3C92,5152
	dc.w	2						;end of the player list: an empty String
.tn									;City
	String	'All Stars East'
.ta									;Abbreviation
	String	'ASE'
.tm									;Nickname. 94 left it empty for the all star teams
	String	'All Stars East'
.ar									;Arena
	String	'San Jose Arena'

AllStarsWest						;ASW, $AB2 (94 $674)
.0
	dc.w	.pld-.0
	dc.w	.pad-.0
	dc.w	.tn-.0
	dc.w	.ls-.0
	dc.w	.sr-.0
	dc.w	.godds-.0
.pad
	incbin	..\Extracted\NHL95\Graphics\Pals\ASWh95.pal
	incbin	..\Extracted\NHL95\Graphics\Pals\ASWv95.pal
.sr
	dc.w	$7720,$00C6
.godds
	dc.b	172,176
.ls
	dc.b	01,21,20,08,04,12,05,00
	dc.b	01,21,20,08,05,07,04,00
	dc.b	01,17,16,04,12,13,05,00
	dc.b	01,19,20,15,14,10,04,00
	dc.b	01,21,16,04,05,12,15,00
	dc.b	01,17,19,06,08,13,04,00
	dc.b	01,18,19,09,12,10,05,00
	dc.b	01,21,16,08,14,06,04,00
.pld
	Player	'P024_________',	3165,4564,0000,4444
	Player	'P025_______',	3253,4443,0000,4444
	Player	'P026________',	2964,4664,0000,5454
	Player	'P027________',	9345,4554,4BC4,6043
	Player	'P028_________',	9946,4643,19C4,6160
	Player	'P029__________',	2584,3534,3795,4342
	Player	'P030__________',	2745,5545,3CD5,5253
	Player	'P031__________',	9176,6654,2BC5,5253
	Player	'P032_________',	0993,3344,4773,4334
	Player	'P033___________',	14B3,2534,3A95,5432
	Player	'P034____________',	19A3,3545,3AA5,4244
	Player	'P035______',	1056,6625,29C5,4542
	Player	'P036_________',	1365,6524,38C5,5442
	Player	'P037______',	1694,4536,3A94,4432
	Player	'P038__________',	2665,6434,2C93,4342
	Player	'P039_____',	04A4,4444,4AA2,4344
	Player	'P040_______',	0284,4446,3892,5343
	Player	'P041____________',	07A4,3233,3761,3142
	Player	'P042___________',	0673,4434,2B94,4242
	Player	'P043_________',	0774,4465,4AA2,6245
	Player	'P044_______',	7796,5434,2BC2,5163
	dc.w	2
.tn
	String	'All Stars West'
.ta
	String	'ASW'
.tm
	String	'All Stars West'
.ar
	String	'San Jose Arena'

Anaheim								;ANH, $D66 (94 $5330)
.0
	dc.w	.pld-.0
	dc.w	.pad-.0
	dc.w	.tn-.0
	dc.w	.ls-.0
	dc.w	.sr-.0
	dc.w	.godds-.0
.pad
	incbin	..\Extracted\NHL95\Graphics\Pals\ANHh95.pal
	incbin	..\Extracted\NHL95\Graphics\Pals\ANHv95.pal
.sr
	dc.w	$0500,$01E7
.godds
	dc.b	180,0
.ls
	dc.b	01,21,18,13,03,08,05,00
	dc.b	01,21,18,13,03,08,05,00
	dc.b	01,19,23,15,05,09,03,00
	dc.b	01,17,22,12,04,11,03,00
	dc.b	01,21,18,05,04,08,03,00
	dc.b	01,19,23,13,03,09,08,00
	dc.b	01,19,23,13,03,08,09,00
	dc.b	01,21,18,15,06,09,03,00
.pld
	Player	'P045______',	3164,3332,0000,3333
	Player	'P046______________',	3562,2223,0000,2222
	Player	'P047______',	20A3,3333,3863,3522
	Player	'P048__________',	4753,3433,2664,4231
	Player	'P049___________',	1973,4343,2763,4032
	Player	'P050__________',	2292,2222,3B62,3122
	Player	'P051_____',	1483,3323,3B63,3322
	Player	'P052______',	2563,4423,3A64,4232
	Player	'P053________',	1683,3233,2832,2421
	Player	'P054_____',	36B1,1212,3852,2315
	Player	'P055_______',	1772,2322,2663,3422
	Player	'P056______',	24A2,3232,4971,3212
	Player	'P057______',	1872,2233,3973,3323
	Player	'P058_______',	32B1,1021,2B21,2515
	Player	'P059_______',	0873,2333,1B63,3421
	Player	'P060___________',	2172,2322,0762,2322
	Player	'P061__________',	0482,2222,2832,2423
	Player	'P062_____',	0683,3222,2662,3324
	Player	'P063________',	02A3,2243,3962,3222
	Player	'P064_______',	3982,1223,2762,2222
	Player	'P065________',	23B1,2223,2B63,3422
	Player	'P066_______',	0382,1222,2732,2322
	Player	'P067___________',	29B3,2141,3971,4514
	dc.w	2
.tn
	String	'Anaheim'
.ta
	String	'ANH'
.tm
	String	'N01_________'
.ar
	String	'Arrowhead Pond'

Boston								;BOS, $102A (94 $966)
.0
	dc.w	.pld-.0
	dc.w	.pad-.0
	dc.w	.tn-.0
	dc.w	.ls-.0
	dc.w	.sr-.0
	dc.w	.godds-.0
.pad
	incbin	..\Extracted\NHL95\Graphics\Pals\BOSh95.pal
	incbin	..\Extracted\NHL95\Graphics\Pals\BOSv95.pal
.sr
	dc.w	$4520,$10E8
.godds
	dc.b	178,0
.ls
	dc.b	01,18,20,06,03,08,06,00
	dc.b	01,18,21,14,03,08,06,00
	dc.b	01,20,22,15,06,10,03,00
	dc.b	01,19,23,16,07,12,03,00
	dc.b	01,18,20,14,03,08,06,00
	dc.b	01,19,22,15,06,10,03,00
	dc.b	01,18,21,15,03,08,06,00
	dc.b	01,19,23,16,06,10,03,00
.pld
	Player	'P068_____',	3024,3343,0000,4343
	Player	'P069____________',	3763,3222,0000,3222
	Player	'P070______',	1275,4653,3A54,5061
	Player	'P071_________',	2252,2222,1863,3231
	Player	'P072________',	4582,2221,1832,2321
	Player	'P073___________',	2004,4433,2A93,3433
	Player	'P074______',	3373,3213,1463,2423
	Player	'P075_____',	08A3,3545,4045,5444
	Player	'P076_________',	2763,2334,3473,4433
	Player	'P077__________',	2363,4333,3A33,3431
	Player	'P078_______',	4404,3323,2A64,3422
	Player	'P079______________',	1973,3322,1262,3332
	Player	'P080________',	1863,3232,3972,2534
	Player	'P081_____________',	1064,4413,1794,4241
	Player	'P082______',	2143,4343,2D33,3332
	Player	'P083_____',	1793,3233,2B24,4220
	Player	'P084________',	2583,3234,3921,3543
	Player	'P085_______',	77A5,4555,49C5,6452
	Player	'P086______',	3492,2242,3672,4523
	Player	'P087______',	43B4,4446,49A2,3344
	Player	'P088_______',	3244,3343,46A1,4142
	Player	'P089_______',	2685,4444,3B42,4442
	Player	'P090__________',	1473,2131,3723,3023
	Player	'P091___________',	06B3,3122,4743,2325
	dc.w	2
.tn
	String	'Boston'
.ta
	String	'BOS'
.tm
	String	'N02___'
.ar
	String	'Boston Garden'

Buffalo								;BUF, $1304 (94 $C4C)
.0
	dc.w	.pld-.0
	dc.w	.pad-.0
	dc.w	.tn-.0
	dc.w	.ls-.0
	dc.w	.sr-.0
	dc.w	.godds-.0
.pad
	incbin	..\Extracted\NHL95\Graphics\Pals\BUFh95.pal
	incbin	..\Extracted\NHL95\Graphics\Pals\BUFv95.pal
.sr
	dc.w	$5320,$10F7
.godds
	dc.b	91,0
.ls
	dc.b	01,19,23,05,04,14,09,00
	dc.b	01,19,24,09,04,14,05,00
	dc.b	01,20,22,10,05,16,14,00
	dc.b	01,18,23,13,08,15,04,00
	dc.b	01,19,24,09,04,14,05,00
	dc.b	01,21,23,10,05,16,14,00
	dc.b	01,23,24,08,05,16,04,00
	dc.b	01,20,22,09,03,15,05,00
.pld
	Player	'P092_________',	3945,3554,0000,5656
	Player	'P093______',	3175,4555,0100,3455
	Player	'P094_______',	1463,2232,2B63,2122
	Player	'P095__________',	1655,4644,24C4,6252
	Player	'P096__________',	1066,4544,2BC3,4052
	Player	'P097_______',	2093,2353,3734,4233
	Player	'P098___',	32A3,4121,4B52,1515
	Player	'P099______',	1982,5342,3D33,4423
	Player	'P100________',	1374,3444,3694,4332
	Player	'P101____',	2792,2323,4B43,3524
	Player	'P102_________',	2283,3434,2364,3132
	Player	'P103______',	4383,3323,2964,3431
	Player	'P104________',	2644,4433,2B93,3241
	Player	'P105____________',	8976,6634,1794,4451
	Player	'P106_________',	1863,3343,3673,3423
	Player	'P107__________',	2853,3434,2664,3532
	Player	'P108___________',	3672,2212,3952,3324
	Player	'P109________',	24A3,2212,3841,1124
	Player	'P110_______',	08A4,3342,2991,4132
	Player	'P111______',	4183,2242,1932,3232
	Player	'P112____________',	0473,3323,2892,3243
	Player	'P113______',	0592,2152,4B61,4223
	Player	'P114________',	0754,4243,3970,4033
	Player	'P115___________',	42A3,2344,3D63,3332
	dc.w	2
.tn
	String	'Buffalo'
.ta
	String	'BUF'
.tm
	String	'N03___'
.ar
	String	'Memorial Auditorium'

Calgary								;CGY, $15E0 (94 $F3A)
.0
	dc.w	.pld-.0
	dc.w	.pad-.0
	dc.w	.tn-.0
	dc.w	.ls-.0
	dc.w	.sr-.0
	dc.w	.godds-.0
.pad
	incbin	..\Extracted\NHL95\Graphics\Pals\CGYh95.pal
	incbin	..\Extracted\NHL95\Graphics\Pals\CGYv95.pal
.sr
	dc.w	$6521,$21CA
.godds
	dc.b	196,0
.ls
	dc.b	01,16,18,09,03,12,14,00
	dc.b	01,16,18,09,03,14,12,00
	dc.b	01,17,21,08,04,12,03,00
	dc.b	01,19,20,10,05,11,03,00
	dc.b	01,16,18,09,03,12,14,00
	dc.b	01,17,21,08,04,11,03,00
	dc.b	01,16,18,08,12,04,03,00
	dc.b	01,17,21,09,03,07,14,00
.pld
	Player	'P116_______',	3043,4444,0000,4444
	Player	'P117_______',	3733,3222,0000,3322
	Player	'P118__________',	2584,3534,3795,4342
	Player	'P119__________',	2664,3435,2D95,3342
	Player	'P120_____',	29B3,2253,5A74,4225
	Player	'P121____________',	9254,4433,2792,3142
	Player	'P122_______',	1163,2343,4263,4133
	Player	'P123________',	1373,3333,3964,3532
	Player	'P124________',	1073,4544,49A5,5345
	Player	'P125______',	1292,2222,3952,3424
	Player	'P126____',	1762,3332,1663,3131
	Player	'P127__________',	1435,5444,4CA4,4333
	Player	'P128__________',	1571,1222,3A52,3425
	Player	'P129________',	2282,2212,3852,2325
	Player	'P130_________',	2172,2122,2631,3422
	Player	'P131___________',	33A5,4434,3792,5332
	Player	'P132_________',	0695,4343,3692,3242
	Player	'P133_______',	0284,4446,3892,5343
	Player	'P134_______',	3972,2131,2762,2513
	Player	'P135________',	1873,3242,2762,3232
	Player	'P136_______',	0393,4142,3941,3323
	Player	'P137________',	0793,3234,4671,3223
	Player	'P138______',	0473,2141,3461,3132
	Player	'P139___________',	0583,2142,3971,3323
	dc.w	2
.tn
	String	'Calgary'
.ta
	String	'CGY'
.tm
	String	'N04___'
.ar
	String	'Olympic Saddledome'

Chicago								;CHI, $18BE (94 $1234)
.0
	dc.w	.pld-.0
	dc.w	.pad-.0
	dc.w	.tn-.0
	dc.w	.ls-.0
	dc.w	.sr-.0
	dc.w	.godds-.0
.pad
	incbin	..\Extracted\NHL95\Graphics\Pals\CHIh95.pal
	incbin	..\Extracted\NHL95\Graphics\Pals\CHIv95.pal
.sr
	dc.w	$2310,$11E8
.godds
	dc.b	196,0
.ls
	dc.b	01,19,18,09,03,16,14,00
	dc.b	01,19,18,11,03,14,16,00
	dc.b	01,24,23,08,04,16,03,00
	dc.b	01,17,20,09,05,13,03,00
	dc.b	01,18,23,14,03,16,08,00
	dc.b	01,24,19,08,04,13,11,00
	dc.b	01,19,18,04,03,14,11,00
	dc.b	01,24,23,05,13,11,14,00
.pld
	Player	'P140______',	3066,4665,0000,6655
	Player	'P141________',	3152,3112,0000,2222
	Player	'P142__________',	2745,5545,3CD5,5253
	Player	'P143___________',	2284,4343,4762,4243
	Player	'P144________',	1263,2353,47A3,5134
	Player	'P145_______',	1172,3312,2662,3232
	Player	'P146__________',	3273,3223,1962,3221
	Player	'P147_________',	1474,4343,2963,3342
	Player	'P148_________',	1684,3332,2564,3312
	Player	'P149____________',	1962,3233,3972,3533
	Player	'P150__________',	44A3,3323,3963,5232
	Player	'P151________',	2091,1211,3624,1315
	Player	'P152_______',	3384,3353,4872,4534
	Player	'P153_______',	1064,5434,1D63,4532
	Player	'P154_______',	1573,3241,2A42,4424
	Player	'P155______',	1774,5434,3B73,4343
	Player	'P156_________',	02A3,4333,3962,4132
	Player	'P157_________',	0774,4465,4AA2,6245
	Player	'P158_______',	05B4,4343,4772,5244
	Player	'P159__________',	2373,3132,3870,4433
	Player	'P160________',	0492,3212,3962,1424
	Player	'P161______',	03A1,1110,1621,1405
	Player	'P162______',	0675,4444,47A2,5244
	Player	'P163_______',	0853,3132,3951,3525
	dc.w	2
.tn
	String	'Chicago'
.ta
	String	'CHI'
.tm
	String	'N05_______'
.ar
	String	'United Center'

Detroit								;DET, $1B9E (94 $152E)
.0
	dc.w	.pld-.0
	dc.w	.pad-.0
	dc.w	.tn-.0
	dc.w	.ls-.0
	dc.w	.sr-.0
	dc.w	.godds-.0
.pad
	incbin	..\Extracted\NHL95\Graphics\Pals\DETh95.pal
	incbin	..\Extracted\NHL95\Graphics\Pals\DETv95.pal
.sr
	dc.w	$7621,$20E8
.godds
	dc.b	138,0
.ls
	dc.b	01,19,18,04,03,13,14,00
	dc.b	01,21,18,05,03,14,04,00
	dc.b	01,19,23,08,04,13,03,00
	dc.b	01,22,20,09,06,07,03,00
	dc.b	01,21,18,05,03,14,04,00
	dc.b	01,19,23,08,04,13,03,00
	dc.b	01,19,23,09,04,03,14,00
	dc.b	01,21,20,05,03,14,04,00
.pld
	Player	'P164_______',	3533,4433,0000,3333
	Player	'P165________',	3034,3343,0000,3333
	Player	'P166_________',	1966,5644,18C4,6151
	Player	'P167__________',	9176,6654,2BC5,5253
	Player	'P168_________',	55B2,2433,3975,3224
	Player	'P169_______',	3373,4242,2962,4232
	Player	'P170________',	2363,3322,2962,3322
	Player	'P171___________',	1354,3423,1B94,3532
	Player	'P172______',	1162,2242,3772,3124
	Player	'P173_______',	24B4,3223,4952,4236
	Player	'P174__________',	2772,2222,2763,3221
	Player	'P175__________',	1273,3222,2762,4021
	Player	'P176___________',	2255,3525,2675,4344
	Player	'P177________',	2662,2513,1865,3421
	Player	'P178__________',	25A2,2232,4A52,4326
	Player	'P179___________',	1543,5222,1833,2521
	Player	'P180_________',	2973,2133,1931,2221
	Player	'P181_______',	7796,5434,2BC2,5163
	Player	'P182__________',	0393,3444,3B72,4234
	Player	'P183_________',	02A1,2132,3741,3024
	Player	'P184____________',	0554,3344,2B61,4241
	Player	'P185_____',	0463,2343,2361,3031
	Player	'P186_______________',	1664,4243,4A71,4235
	Player	'P187________',	2191,2122,3742,3224
	dc.w	2
.tn
	String	'Detroit'
.ta
	String	'DET'
.tm
	String	'N06______'
.ar
	String	'Joe Louis Sports Arena'

Edmonton							;EDM, $1E9C (94 $1848)
.0
	dc.w	.pld-.0
	dc.w	.pad-.0
	dc.w	.tn-.0
	dc.w	.ls-.0
	dc.w	.sr-.0
	dc.w	.godds-.0
.pad
	incbin	..\Extracted\NHL95\Graphics\Pals\EDMh95.pal
	incbin	..\Extracted\NHL95\Graphics\Pals\EDMv95.pal
.sr
	dc.w	$2511,$02F6
.godds
	dc.b	181,0
.ls
	dc.b	01,19,22,10,03,13,05,00
	dc.b	01,19,24,10,03,14,05,00
	dc.b	01,22,20,13,05,16,03,00
	dc.b	01,23,21,12,07,17,03,00
	dc.b	01,19,20,10,03,14,05,00
	dc.b	01,22,18,13,05,16,03,00
	dc.b	01,23,22,10,03,05,14,00
	dc.b	01,19,24,17,05,03,14,00
.pld
	Player	'P188________',	3045,3435,0000,4455
	Player	'P189___________',	3152,2222,0000,2122
	Player	'P190_______',	3963,3433,3DA3,3243
	Player	'P191_________',	3674,4223,0263,3232
	Player	'P192________',	0783,3444,3AA4,3343
	Player	'P193_________',	3773,4243,2962,3221
	Player	'P194__________',	1793,3132,2742,3223
	Player	'P195__________',	2563,3222,2A62,2530
	Player	'P196________',	3493,4223,3974,3322
	Player	'P197_________',	0993,3344,4773,4334
	Player	'P198_________',	29C1,1212,3753,1515
	Player	'P199_________',	3393,3122,3542,3123
	Player	'P200_______',	0873,3334,2D64,3230
	Player	'P201_______',	12B2,2322,2742,2223
	Player	'P202________',	2692,2322,2734,2512
	Player	'P203_______',	1873,2232,3872,4323
	Player	'P204____________',	16A3,3232,4C72,3214
	Player	'P205_______',	1073,2322,0763,2240
	Player	'P206_________',	2195,3344,3B92,4332
	Player	'P207____________',	1594,3434,1892,3141
	Player	'P208________',	3592,2121,2640,1312
	Player	'P209_____',	0293,3233,3A72,3323
	Player	'P210___________',	22B3,3132,4970,2434
	Player	'P211_________',	2064,3223,3871,2323
	dc.w	2
.tn
	String	'Edmonton'
.ta
	String	'EDM'
.tm
	String	'N07___'
.ar
	String	'Northlands Coliseum'

Florida								;FLA, $218E (94 $50E6)
.0
	dc.w	.pld-.0
	dc.w	.pad-.0
	dc.w	.tn-.0
	dc.w	.ls-.0
	dc.w	.sr-.0
	dc.w	.godds-.0
.pad
	incbin	..\Extracted\NHL95\Graphics\Pals\FLAh95.pal
	incbin	..\Extracted\NHL95\Graphics\Pals\FLAv95.pal
.sr
	dc.w	$1200,$00E8
.godds
	dc.b	196,0
.ls
	dc.b	01,17,20,10,06,15,03,00
	dc.b	01,17,20,10,06,15,03,00
	dc.b	01,23,18,08,03,13,06,00
	dc.b	01,24,21,09,04,14,06,00
	dc.b	01,24,20,10,06,15,03,00
	dc.b	01,17,21,09,04,14,06,00
	dc.b	01,23,21,08,03,10,06,00
	dc.b	01,17,18,13,04,06,03,00
.pld
	Player	'P212___________',	3454,3453,0000,4455
	Player	'P213___________',	3073,4223,0000,3434
	Player	'P214___________',	2084,3252,4973,4334
	Player	'P215______',	1452,3433,2893,3431
	Player	'P216__________',	4494,5223,3773,3422
	Player	'P217__________',	2653,4433,2894,3241
	Player	'P218__________',	2182,3233,3A63,3222
	Player	'P219______',	1873,2233,3972,3233
	Player	'P220______',	1082,3332,3B72,3424
	Player	'P221__________',	1974,3333,1993,3242
	Player	'P222________',	1161,2232,2D41,2322
	Player	'P223________',	2392,2122,2933,2421
	Player	'P224_____',	1292,2232,3432,3321
	Player	'P225__________',	2791,1333,4A74,3324
	Player	'P226________',	2292,3434,2C64,3432
	Player	'P227________',	1782,2232,4243,3423
	Player	'P228_________',	0783,2323,2762,4234
	Player	'P229_______',	2594,3131,2491,3231
	Player	'P230_________',	24A2,2133,4752,3325
	Player	'P231_______',	0585,4334,3C62,3333
	Player	'P232_______',	02A2,2133,3642,3323
	Player	'P233_____',	0393,2022,4621,3325
	Player	'P234_______',	0472,2232,3441,3433
	Player	'P235___________',	0693,3322,2992,3342
	dc.w	2
.tn
	String	'Florida'
.ta
	String	'FLA'
.tm
	String	'N08_____'
.ar
	String	'Miami Arena'

Hartford							;HFD, $246E (94 $1B44)
.0
	dc.w	.pld-.0
	dc.w	.pad-.0
	dc.w	.tn-.0
	dc.w	.ls-.0
	dc.w	.sr-.0
	dc.w	.godds-.0
.pad
	incbin	..\Extracted\NHL95\Graphics\Pals\HFDh95.pal
	incbin	..\Extracted\NHL95\Graphics\Pals\HFDv95.pal
.sr
	dc.w	$1102,$02E7
.godds
	dc.b	196,16
.ls
	dc.b	01,19,23,09,04,15,06,00
	dc.b	01,20,18,09,04,15,06,00
	dc.b	01,19,23,13,06,17,08,00
	dc.b	01,22,24,12,08,14,04,00
	dc.b	01,20,23,09,04,15,06,00
	dc.b	01,22,18,08,06,17,04,00
	dc.b	01,20,23,15,04,09,06,00
	dc.b	01,22,18,10,05,09,06,00
.pld
	Player	'P236______',	01A4,3223,0000,3344
	Player	'P237______',	3542,3322,0000,2222
	Player	'P238____________',	4063,3113,0000,2222
	Player	'P239__________',	2173,3442,2B33,4142
	Player	'P240_________',	22B3,2243,4D73,4124
	Player	'P241_____',	1774,4232,3592,3232
	Player	'P242_________',	3253,4323,1763,3231
	Player	'P243___________',	8964,4434,2792,4331
	Player	'P244___________',	0864,5434,2B64,4331
	Player	'P245_______',	2683,3233,3532,2530
	Player	'P246_______',	20B3,3232,3933,4224
	Player	'P247_____',	2493,3232,3972,4332
	Player	'P248___________',	2394,4334,3B72,3314
	Player	'P249________',	1484,5333,1A62,3431
	Player	'P250_______',	1673,4434,3CA4,4444
	Player	'P251_______',	41B1,2233,2442,3324
	Player	'P252_______',	1853,4342,2993,3330
	Player	'P253___________',	2783,3242,4741,3215
	Player	'P254_____________',	05A2,3232,3972,3512
	Player	'P255_____',	0674,3234,4771,4334
	Player	'P256__________',	1083,2142,4430,3133
	Player	'P257___________',	0493,3243,2961,3422
	Player	'P258_________',	4473,3332,3BA2,3334
	Player	'P259_______',	3373,3232,2872,3322
	dc.w	2
.tn
	String	'Hartford'
.ta
	String	'HFD'
.tm
	String	'N09____'
.ar
	String	'Hartford Civic Center'

LosAngeles							;LA, $2762 (94 $1E52)
.0
	dc.w	.pld-.0
	dc.w	.pad-.0
	dc.w	.tn-.0
	dc.w	.ls-.0
	dc.w	.sr-.0
	dc.w	.godds-.0
.pad
	incbin	..\Extracted\NHL95\Graphics\Pals\LAh95.pal
	incbin	..\Extracted\NHL95\Graphics\Pals\LAv95.pal
.sr
	dc.w	$4621,$02D8
.godds
	dc.b	168,0
.ls
	dc.b	01,16,17,08,03,11,04,00
	dc.b	01,16,18,10,03,11,04,00
	dc.b	01,17,22,08,04,15,03,00
	dc.b	01,19,20,07,05,12,03,00
	dc.b	01,16,18,08,03,11,04,00
	dc.b	01,17,19,10,04,12,03,00
	dc.b	01,16,19,07,11,03,08,00
	dc.b	01,18,20,10,03,11,08,00
.pld
	Player	'P260________',	3263,3343,0000,2223
	Player	'P261________',	3562,3443,0000,2222
	Player	'P262_________',	9946,4643,19C4,6160
	Player	'P263_______',	1363,3322,1664,3240
	Player	'P264______',	1452,3333,2742,3332
	Player	'P265____________',	2683,3132,3B33,3232
	Player	'P266________',	1572,2232,2963,2432
	Player	'P267__________',	2074,4535,2B96,5443
	Player	'P268_________',	1073,2211,3B52,1415
	Player	'P269_________',	1164,4332,3B63,4332
	Player	'P270______',	1784,3444,2B94,4232
	Player	'P271________',	2164,5443,36A4,3335
	Player	'P272______',	0993,3333,3864,3123
	Player	'P273________',	1462,2211,2632,1322
	Player	'P274______',	1992,2342,3633,3322
	Player	'P275_____',	04A4,4444,4AA2,4344
	Player	'P276__________',	33C2,2243,4782,5436
	Player	'P277________',	0265,4333,3B92,4143
	Player	'P278________',	2594,3323,3DA1,3332
	Player	'P279_________',	22A3,2243,3972,3132
	Player	'P280____',	0782,3122,2731,3122
	Player	'P281______',	0672,2122,3631,2414
	Player	'P282_______',	0562,2121,2510,2122
	dc.w	2
.tn
	String	'Los Angeles'
.ta
	String	'LA'
.tm
	String	'N10__'
.ar
	String	'The Great Western Forum'

Dallas								;DAL, $2A24 (94 $214E)
.0
	dc.w	.pld-.0
	dc.w	.pad-.0
	dc.w	.tn-.0
	dc.w	.ls-.0
	dc.w	.sr-.0
	dc.w	.godds-.0
.pad
	incbin	..\Extracted\NHL95\Graphics\Pals\DALh95.pal
	incbin	..\Extracted\NHL95\Graphics\Pals\DALv95.pal
.sr
	dc.w	$5310,$20F7
.godds
	dc.b	181,0
.ls
	dc.b	01,19,20,04,03,16,08,00
	dc.b	01,19,23,08,03,16,04,00
	dc.b	01,24,20,10,04,14,03,00
	dc.b	01,21,18,11,05,17,03,00
	dc.b	01,19,23,09,03,16,08,00
	dc.b	01,24,20,10,04,14,03,00
	dc.b	01,19,24,11,05,03,16,00
	dc.b	01,21,20,17,07,03,16,00
.pld
	Player	'P283_____',	3543,3123,0000,3233
	Player	'P284_________',	3463,3334,0000,3344
	Player	'P285_______',	0975,5645,29C4,5342
	Player	'P286_______',	1564,4433,2994,4444
	Player	'P287_______',	0743,4353,2962,4241
	Player	'P288_____',	1082,2132,3472,3222
	Player	'P289_______',	1662,2232,2A73,3133
	Player	'P290_______',	2993,3322,1863,3321
	Player	'P291________',	0655,3433,2593,4041
	Player	'P292___________',	4164,3323,3973,2532
	Player	'P293_______',	1794,3343,4B73,4422
	Player	'P294____',	2393,2233,3851,3425
	Player	'P295________',	2792,2221,4852,2125
	Player	'P296______',	2063,3323,3673,3323
	Player	'P297________',	3062,2222,2843,2421
	Player	'P298__________',	2665,6434,2C93,4342
	Player	'P299_______',	2172,2241,2662,3314
	Player	'P300_______',	0584,3232,3571,3235
	Player	'P301________',	2493,3344,5773,4325
	Player	'P302__________',	0293,2242,4B72,4224
	Player	'P303________',	03C2,2142,3B40,3324
	Player	'P304_____________',	0473,3133,3931,3522
	Player	'P305_________',	1294,3331,3960,2232
	Player	'P306__________',	14A3,3243,3962,3532
	dc.w	2
.tn
	String	'Dallas'
.ta
	String	'DAL'
.tm
	String	'N11__'
.ar
	String	'Reunion Arena'

Montreal							;MTL, $2CF8 (94 $243E)
.0
	dc.w	.pld-.0
	dc.w	.pad-.0
	dc.w	.tn-.0
	dc.w	.ls-.0
	dc.w	.sr-.0
	dc.w	.godds-.0
.pad
	incbin	..\Extracted\NHL95\Graphics\Pals\MTLh95.pal
	incbin	..\Extracted\NHL95\Graphics\Pals\MTLv95.pal
.sr
	dc.w	$3620,$21E8
.godds
	dc.b	211,0
.ls
	dc.b	01,18,17,09,03,14,04,00
	dc.b	01,24,17,09,03,14,04,00
	dc.b	01,18,23,08,04,13,03,00
	dc.b	01,21,19,10,05,15,03,00
	dc.b	01,18,17,09,03,14,04,00
	dc.b	01,21,19,08,06,13,03,00
	dc.b	01,24,17,10,05,03,09,00
	dc.b	01,18,23,04,03,09,14,00
.pld
	Player	'P307_______',	3366,4355,0000,5666
	Player	'P308_______',	0122,3231,0000,1122
	Player	'P309_______',	1194,4444,4BA3,4144
	Player	'P310________',	17B3,4335,3962,3122
	Player	'P311__________',	2164,3252,4861,4241
	Player	'P312_________',	1563,3323,2862,3221
	Player	'P313______',	0863,2241,2732,4222
	Player	'P314__________',	4583,2422,3994,3232
	Player	'P315______________',	2564,4524,1DC5,4242
	Player	'P316_________',	2262,2322,2323,2222
	Player	'P317_________',	3261,1112,3742,1314
	Player	'P318__________',	2072,2212,1772,1223
	Player	'P319______',	1253,4342,4A62,4033
	Player	'P320_________',	2384,4424,2994,4342
	Player	'P321_______',	0643,2332,1762,3330
	Player	'P322____',	3182,2212,3222,1421
	Player	'P323___________',	2894,3354,4C72,4333
	Player	'P324__________',	2774,4444,2762,4343
	Player	'P325_____________',	4353,2333,2663,3322
	Player	'P326________',	1463,2232,2772,4523
	Player	'P327_________',	4481,1211,2760,1011
	Player	'P328___________',	4864,3233,1762,4221
	Player	'P329________',	2493,2243,4B52,3425
	Player	'P330_________',	34A2,2123,3661,2211
	dc.w	2
.tn
	String	'Montreal'
.ta
	String	'MTL'
.tm
	String	'N12______'
.ar
	String	'Montreal Forum'

NewJersey							;NJ, $2FE8 (94 $2740)
.0
	dc.w	.pld-.0
	dc.w	.pad-.0
	dc.w	.tn-.0
	dc.w	.ls-.0
	dc.w	.sr-.0
	dc.w	.godds-.0
.pad
	incbin	..\Extracted\NHL95\Graphics\Pals\NJh95.pal
	incbin	..\Extracted\NHL95\Graphics\Pals\NJv95.pal
.sr
	dc.w	$6411,$20F7
.godds
	dc.b	92,0
.ls
	dc.b	01,21,18,16,05,15,04,00
	dc.b	01,21,18,16,04,15,05,00
	dc.b	01,20,22,08,05,14,04,00
	dc.b	01,19,23,11,06,13,04,00
	dc.b	01,21,18,16,04,15,05,00
	dc.b	01,20,23,08,05,14,04,00
	dc.b	01,21,18,16,04,15,05,00
	dc.b	01,20,22,11,06,15,04,00
.pld
	Player	'P331_________',	3124,4443,0000,4433
	Player	'P332__________',	3075,3344,0000,5555
	Player	'P333__________',	2063,2333,2693,3232
	Player	'P334___________',	0963,2443,2893,4143
	Player	'P335________',	1043,5422,1494,3233
	Player	'P336_________',	1973,2242,2931,3333
	Player	'P337____',	1173,4322,1862,3132
	Player	'P338____________',	2564,4443,1B94,3232
	Player	'P339_______',	16A2,3224,3862,3323
	Player	'P340_______',	2163,2233,4A83,3425
	Player	'P341_______',	1794,4332,3A63,3322
	Player	'P342_______',	0891,2222,4921,4415
	Player	'P343__________',	22B4,4334,4872,4334
	Player	'P344_______',	1294,3335,4A74,3524
	Player	'P345________',	1593,2544,3873,4524
	Player	'P346___________',	4494,4435,2AC4,4432
	Player	'P347_______',	2683,3132,3871,3232
	Player	'P348_________',	04B4,4464,5D73,5145
	Player	'P349____________',	02B4,2132,2931,3133
	Player	'P350________',	2364,3342,3B62,4232
	Player	'P351____________',	2793,3333,3992,3142
	Player	'P352_______',	03A3,2151,5D40,4414
	Player	'P353_________',	0673,2232,2960,3232
	Player	'P354__________',	0583,3132,2961,3221
	dc.w	2
.tn
	String	'New Jersey'
.ta
	String	'NJ'
.tm
	String	'N13___'
.ar
	String	'Brendan Byrne Arena'

NewYorkI							;NYI, $32DA (94 $2A58)
.0
	dc.w	.pld-.0
	dc.w	.pad-.0
	dc.w	.tn-.0
	dc.w	.ls-.0
	dc.w	.sr-.0
	dc.w	.godds-.0
.pad
	incbin	..\Extracted\NHL95\Graphics\Pals\NYIh95.pal
	incbin	..\Extracted\NHL95\Graphics\Pals\NYIv95.pal
.sr
	dc.w	$5221,$12F7
.godds
	dc.b	181,0
.ls
	dc.b	01,18,19,08,03,13,10,00
	dc.b	01,19,20,10,03,13,08,00
	dc.b	01,18,24,08,04,14,03,00
	dc.b	01,21,22,09,06,15,03,00
	dc.b	01,18,20,10,03,13,08,00
	dc.b	01,21,22,08,04,14,03,00
	dc.b	01,19,20,08,03,10,13,00
	dc.b	01,18,24,09,04,03,13,00
.pld
	Player	'P355_______',	7273,4443,0000,2233
	Player	'P356__________',	2973,3222,0000,2222
	Player	'P357__________',	7794,4534,0995,4140
	Player	'P358_______',	2063,3334,2993,4433
	Player	'P359_______',	2442,2243,3972,4233
	Player	'P360________',	3983,2324,3A62,3422
	Player	'P361___________',	1083,2211,3363,1524
	Player	'P362________',	3374,5433,1964,4143
	Player	'P363_________',	1843,3342,2A64,3022
	Player	'P364______',	2793,2414,0965,4421
	Player	'P365_______',	0881,1112,3750,1414
	Player	'P366______',	2564,4322,1262,4532
	Player	'P367________',	3264,4434,4974,4234
	Player	'P368_________',	15B2,2231,3664,2123
	Player	'P369___________',	2683,2342,4242,4144
	Player	'P370_______',	1282,2011,3A51,2415
	Player	'P371________',	1763,2212,1562,2421
	Player	'P372_____________',	23A4,3434,2962,4333
	Player	'P373_____________',	1174,3233,4961,2234
	Player	'P374_____',	04E3,2334,2662,4132
	Player	'P375_______',	2883,3424,2961,4132
	Player	'P376__________',	0782,2243,3962,4133
	Player	'P377________',	37A1,1212,2741,1113
	Player	'P378_________',	4794,2023,3571,2515
	dc.w	2
.tn
	String	'New York'
.ta
	String	'NYI'
.tm
	String	'N14______'
.ar
	String	'Nassau Coliseum'

NewYorkR							;NYR, $35C6 (94 $2D5C)
.0
	dc.w	.pld-.0
	dc.w	.pad-.0
	dc.w	.tn-.0
	dc.w	.ls-.0
	dc.w	.sr-.0
	dc.w	.godds-.0
.pad
	incbin	..\Extracted\NHL95\Graphics\Pals\NYRh95.pal
	incbin	..\Extracted\NHL95\Graphics\Pals\NYRv95.pal
.sr
	dc.w	$5620,$20F7
.godds
	dc.b	196,0
.ls
	dc.b	01,18,20,08,03,15,13,00
	dc.b	01,18,21,08,03,13,15,00
	dc.b	01,22,20,14,06,15,03,00
	dc.b	01,24,19,10,04,17,03,00
	dc.b	01,18,20,08,03,13,15,00
	dc.b	01,22,19,10,06,15,03,00
	dc.b	01,18,21,08,03,15,13,00
	dc.b	01,22,20,10,05,03,08,00
.pld
	Player	'P379________',	3575,4344,0000,5555
	Player	'P380_______',	3053,4433,0000,3322
	Player	'P381________',	1195,4433,4993,4253
	Player	'P382____________',	1364,3353,4D64,6232
	Player	'P383___________',	1484,3352,4B62,5223
	Player	'P384__________',	2776,5425,2BC4,3433
	Player	'P385_____',	1293,3334,2A63,3442
	Player	'P386_______',	0994,4433,5D73,4535
	Player	'P387________',	1982,2222,3B54,3415
	Player	'P388________',	1095,4345,4A92,4444
	Player	'P389________',	1772,2242,3763,3112
	Player	'P390_______',	1573,3233,4972,4223
	Player	'P391__________',	3674,4433,2B63,4143
	Player	'P392____________',	3283,3342,3B63,3233
	Player	'P393________',	2874,4464,4B64,6342
	Player	'P394______',	2682,2132,3851,2424
	Player	'P395________',	1673,3444,3A64,4533
	Player	'P396________',	0266,3544,2DC2,5252
	Player	'P397__________',	2563,3232,3862,3232
	Player	'P398________',	2174,4544,3D92,3242
	Player	'P399__________',	23B2,2242,4A71,3024
	Player	'P400______',	0483,3242,3961,3133
	Player	'P401________',	0693,3233,3A61,4142
	Player	'P402_____',	24A2,2132,4B40,2124
	dc.w	2
.tn
	String	'New York'
.ta
	String	'NYR'
.tm
	String	'N15____'
.ar
	String	'Madison Square Garden'

Ottawa								;OTW, $38A8 (94 $3054)
.0
	dc.w	.pld-.0
	dc.w	.pad-.0
	dc.w	.tn-.0
	dc.w	.ls-.0
	dc.w	.sr-.0
	dc.w	.godds-.0
.pad
	incbin	..\Extracted\NHL95\Graphics\Pals\OTWh95.pal
	incbin	..\Extracted\NHL95\Graphics\Pals\OTWv95.pal
.sr
	dc.w	$0002,$02E8
.godds
	dc.b	197,0
.ls
	dc.b	01,19,20,06,04,03,12,00
	dc.b	01,19,21,06,04,12,03,00
	dc.b	01,23,20,07,03,14,04,00
	dc.b	01,22,24,11,05,13,04,00
	dc.b	01,19,23,06,04,03,12,00
	dc.b	01,22,20,07,05,14,12,00
	dc.b	01,19,21,11,05,04,12,00
	dc.b	01,24,20,12,04,03,06,00
.pld
	Player	'P403____________',	0143,4221,0000,2222
	Player	'P404_________',	3582,2121,0000,1111
	Player	'P405___________',	9154,4314,2DA3,3242
	Player	'P406_________',	1974,4414,1AC4,3242
	Player	'P407_______',	3384,3242,4471,3533
	Player	'P408___________',	6194,4424,0533,3523
	Player	'P409___________',	1573,2333,1763,3522
	Player	'P410________',	1062,2122,2531,2424
	Player	'P411_________',	1872,2222,2953,2414
	Player	'P412______',	1682,2212,2762,2432
	Player	'P413________',	2783,4232,3972,5322
	Player	'P414_________',	1773,2332,3663,3532
	Player	'P415_________',	2092,2323,2462,2122
	Player	'P416__________',	1165,4324,1863,3531
	Player	'P417________',	2692,2212,2632,3222
	Player	'P418__________',	2461,1202,0232,2210
	Player	'P419_______',	2192,1132,4951,3414
	Player	'P420_________',	2483,2232,4531,3222
	Player	'P421________',	2263,3423,2792,4133
	Player	'P422_____',	0473,2323,2661,5232
	Player	'P423_________',	3491,2212,3B40,3423
	Player	'P424_________',	0593,3223,3961,3322
	Player	'P425____________',	5593,2122,2661,2221
	Player	'P426_______',	0681,1221,2A30,2513
	dc.w	2
.tn
	String	'Ottawa'
.ta
	String	'OTW'
.tm
	String	'N16_____'
.ar
	String	'Ottawa Civic Centre'

Philadelphia						;PHI, $3B9E (94 $3348)
.0
	dc.w	.pld-.0
	dc.w	.pad-.0
	dc.w	.tn-.0
	dc.w	.ls-.0
	dc.w	.sr-.0
	dc.w	.godds-.0
.pad
	incbin	..\Extracted\NHL95\Graphics\Pals\PHIh95.pal
	incbin	..\Extracted\NHL95\Graphics\Pals\PHIv95.pal
.sr
	dc.w	$6121,$01D9
.godds
	dc.b	90,0
.ls
	dc.b	01,16,17,04,03,12,08,00
	dc.b	01,16,17,08,03,12,04,00
	dc.b	01,18,19,09,04,13,03,00
	dc.b	01,20,22,10,05,14,03,00
	dc.b	01,16,17,09,03,12,04,00
	dc.b	01,20,19,10,04,13,03,00
	dc.b	01,18,19,04,03,08,12,00
	dc.b	01,16,17,05,06,03,04,00
.pld
	Player	'P427___________',	3363,3333,0000,3322
	Player	'P428____________',	3033,3342,0000,2323
	Player	'P429________',	88C4,3445,56A6,5344
	Player	'P430__________',	1794,3444,3D94,4243
	Player	'P431_____',	2264,3242,3D61,3333
	Player	'P432________',	1462,3132,2932,3122
	Player	'P433______',	2072,3232,3662,4223
	Player	'P434_______',	1883,3333,2863,3122
	Player	'P435__________',	1974,3534,3D95,3242
	Player	'P436_________',	4263,3433,1994,3433
	Player	'P437_______',	3672,2222,2964,3322
	Player	'P438_______',	0865,4534,3D95,4343
	Player	'P439________',	1174,4343,2873,4534
	Player	'P440______',	2191,1031,2650,2514
	Player	'P441________',	1552,2232,2862,3222
	Player	'P442________',	0373,3342,3BA1,3233
	Player	'P443______________',	0274,4343,3971,5333
	Player	'P444_______',	28A3,3133,4572,3322
	Player	'P445_______',	2964,4334,3762,4232
	Player	'P446_______',	2673,2122,2941,3434
	Player	'P447_______',	2592,2122,2760,2422
	Player	'P448____________',	2352,2121,3960,3422
	Player	'P449______',	0592,2133,4641,3424
	Player	'P450_______',	2782,2232,3841,3414
	dc.w	2
.tn
	String	'Philadelphia'
.ta
	String	'PHI'
.tm
	String	'N17___'
.ar
	String	'The Spectrum'

Pittsburgh							;PIT, $3E7C (94 $3646)
.0
	dc.w	.pld-.0
	dc.w	.pad-.0
	dc.w	.tn-.0
	dc.w	.ls-.0
	dc.w	.sr-.0
	dc.w	.godds-.0
.pad
	incbin	..\Extracted\NHL95\Graphics\Pals\PITh95.pal
	incbin	..\Extracted\NHL95\Graphics\Pals\PITv95.pal
.sr
	dc.w	$6311,$20D9
.godds
	dc.b	197,0
.ls
	dc.b	01,18,19,07,03,13,12,00
	dc.b	01,18,17,07,03,12,13,00
	dc.b	01,20,19,08,04,13,03,00
	dc.b	01,21,22,09,05,14,03,00
	dc.b	01,18,19,07,03,13,12,00
	dc.b	01,20,17,14,04,12,13,00
	dc.b	01,18,19,13,03,12,07,00
	dc.b	01,20,17,07,04,03,12,00
.pld
	Player	'P451________',	35A4,4554,0100,4344
	Player	'P452_______',	3182,3332,0000,3232
	Player	'P453_________',	66A5,4635,24C6,6162
	Player	'P454_______',	1094,3553,4B93,5152
	Player	'P455___________',	1573,4334,1B63,4432
	Player	'P456__________',	1983,2222,2362,2122
	Player	'P457_________',	25B3,3525,3B75,5444
	Player	'P458______',	0764,3433,3A65,4431
	Player	'P459_________',	8253,4433,1D93,3241
	Player	'P460________',	33A1,1112,3951,3315
	Player	'P461______',	2463,3242,3863,4333
	Player	'P462________',	2292,3434,4674,3334
	Player	'P463________',	68A5,4534,4BC3,6152
	Player	'P464___________',	1794,4535,2763,4434
	Player	'P465__________',	2964,3223,2962,2221
	Player	'P466_______',	0274,3222,3972,2321
	Player	'P467____________',	28E2,2134,4641,4523
	Player	'P468__________',	0584,4243,5B70,4136
	Player	'P469________',	55A4,3554,3C92,5152
	Player	'P470____________',	3291,2133,4440,4424
	Player	'P471_______',	0683,1032,4741,3123
	Player	'P472______',	3473,3322,2862,3222
	Player	'P473________',	0473,3323,2962,3132
	Player	'P474__________',	0392,2132,3970,2414
	dc.w	2
.tn
	String	'Pittsburgh'
.ta
	String	'PIT'
.tm
	String	'N18_____'
.ar
	String	'Pittsburgh Civic Arena'

Quebec								;QUE, $416C (94 $393C)
.0
	dc.w	.pld-.0
	dc.w	.pad-.0
	dc.w	.tn-.0
	dc.w	.ls-.0
	dc.w	.sr-.0
	dc.w	.godds-.0
.pad
	incbin	..\Extracted\NHL95\Graphics\Pals\QUEh95.pal
	incbin	..\Extracted\NHL95\Graphics\Pals\QUEv95.pal
.sr
	dc.w	$5202,$12F7
.godds
	dc.b	166,0
.ls
	dc.b	01,20,19,09,03,05,15,00
	dc.b	01,20,18,09,05,15,03,00
	dc.b	01,19,22,08,03,16,05,00
	dc.b	01,23,24,12,04,17,05,00
	dc.b	01,19,22,09,03,05,15,00
	dc.b	01,20,24,08,04,15,03,00
	dc.b	01,20,18,07,04,03,05,00
	dc.b	01,19,22,06,05,03,09,00
.pld
	Player	'P475__________',	3553,3332,0000,3222
	Player	'P476____________',	4153,3222,0000,2222
	Player	'P477_____',	1964,3543,29C5,5262
	Player	'P478______',	0974,3433,3975,3245
	Player	'P479_______',	1374,4544,1C95,4143
	Player	'P480______',	2263,3342,4473,4244
	Player	'P481___________',	4753,4342,3B62,3124
	Player	'P482___________',	2553,2323,1763,3132
	Player	'P483___________',	3184,4425,2694,4152
	Player	'P484_______',	12D2,1121,3751,0525
	Player	'P485______',	15A1,1101,3920,1414
	Player	'P486_______',	3873,3333,2763,3222
	Player	'P487__________',	1773,4232,2733,2321
	Player	'P488______',	2844,3222,3B33,3323
	Player	'P489______',	1183,4425,2625,4334
	Player	'P490____________',	5133,4433,3694,4232
	Player	'P491_______',	4873,5345,1863,3431
	Player	'P492_________',	5592,3142,5681,4335
	Player	'P493_____________',	0793,4342,3764,5132
	Player	'P494__________',	0563,3333,3763,4132
	Player	'P495________',	2793,3322,1963,2522
	Player	'P496______',	5982,2232,3642,3324
	Player	'P497_______',	2982,2233,3B72,3424
	Player	'P498________',	0264,3324,2892,3331
	dc.w	2
.tn
	String	'Quebec'
.ta
	String	'QUE'
.tm
	String	'N19______'
.ar
	String	'Colisee de Quebec'

SanJose								;SJ, $4452 (94 $3C42)
.0
	dc.w	.pld-.0
	dc.w	.pad-.0
	dc.w	.tn-.0
	dc.w	.ls-.0
	dc.w	.sr-.0
	dc.w	.godds-.0
.pad
	incbin	..\Extracted\NHL95\Graphics\Pals\SJh95.pal
	incbin	..\Extracted\NHL95\Graphics\Pals\SJv95.pal
.sr
	dc.w	$2402,$12E7
.godds
	dc.b	212,0
.ls
	dc.b	01,17,19,14,03,16,10,00
	dc.b	01,17,19,10,03,16,14,00
	dc.b	01,18,20,08,04,14,03,00
	dc.b	01,21,23,09,05,15,03,00
	dc.b	01,17,19,10,03,16,14,00
	dc.b	01,18,20,14,04,15,03,00
	dc.b	01,21,23,09,05,03,14,00
	dc.b	01,18,19,08,03,16,10,00
.pld
	Player	'P499_______',	3254,4443,0000,4444
	Player	'P500_____',	2962,3222,0000,2222
	Player	'P501_________',	0745,3433,1795,3441
	Player	'P502_____',	2773,4333,2963,3223
	Player	'P503_______',	1373,3343,3963,4232
	Player	'P504__________',	3363,3232,3932,3221
	Player	'P505_____________',	0963,2323,2962,2123
	Player	'P506_____',	1265,4242,4762,4523
	Player	'P507___________',	1193,4242,3D63,4521
	Player	'P508___________',	1063,3332,1B64,3231
	Player	'P509_______',	1442,2323,1864,3231
	Player	'P510_______',	3691,2222,2A53,3415
	Player	'P511________',	3763,3332,3C63,4431
	Player	'P512______',	2284,3434,3B94,5340
	Player	'P513_______',	1774,4423,1A63,4530
	Player	'P514__________',	2465,4433,1B95,3252
	Player	'P515_______',	0885,4432,1762,4132
	Player	'P516___________',	2663,3322,1962,3221
	Player	'P517___________',	0673,4434,2B94,4242
	Player	'P518________',	4141,2332,2862,2332
	Player	'P519________',	44A1,1011,2722,1514
	Player	'P520_______',	4083,2132,3971,3323
	Player	'P521____',	0473,2133,4642,3534
	dc.w	2
.tn
	String	'San Jose'
.ta
	String	'SJ'
.tm
	String	'N20___'
.ar
	String	'San Jose Arena'

StLouis								;STL, $4716 (94 $3F30)
.0
	dc.w	.pld-.0
	dc.w	.pad-.0
	dc.w	.tn-.0
	dc.w	.ls-.0
	dc.w	.sr-.0
	dc.w	.godds-.0
.pad
	incbin	..\Extracted\NHL95\Graphics\Pals\STLh95.pal
	incbin	..\Extracted\NHL95\Graphics\Pals\STLv95.pal
.sr
	dc.w	$3421,$21F7
.godds
	dc.b	212,0
.ls
	dc.b	01,22,18,08,03,11,05,00
	dc.b	01,24,18,08,03,11,05,00
	dc.b	01,22,21,09,05,12,11,00
	dc.b	01,20,23,07,04,13,11,00
	dc.b	01,22,18,08,03,11,05,00
	dc.b	01,24,19,05,04,12,11,00
	dc.b	01,24,18,08,12,11,03,00
	dc.b	01,20,21,13,11,03,08,00
.pld
	Player	'P522_________',	3165,4564,0000,4444
	Player	'P523_______',	2962,3222,0000,2222
	Player	'P524________',	1574,3543,27C4,4060
	Player	'P525_________',	2694,3433,3794,3241
	Player	'P526_______',	9353,3433,19C5,4342
	Player	'P527__________',	1073,2322,2A62,3232
	Player	'P528_______',	1792,2122,3751,3415
	Player	'P529____________',	19A3,3545,3AA5,4244
	Player	'P530____________',	2573,3312,1763,2431
	Player	'P531_______',	2392,2223,2732,2323
	Player	'P532______',	1694,4536,3A94,4432
	Player	'P533________',	1474,3443,3863,4333
	Player	'P534__________',	3662,2232,1961,2523
	Player	'P535___________',	1272,2222,2762,3321
	Player	'P536________',	3872,2232,2961,3021
	Player	'P537_______',	3981,1111,2851,2415
	Player	'P538_________',	0982,2222,2933,2422
	Player	'P539________',	0666,5533,27C2,4062
	Player	'P540_________',	3272,2322,2762,4031
	Player	'P541________',	34A3,3122,2971,2513
	Player	'P542______',	0483,3133,3860,4022
	Player	'P543__________',	2884,4444,1B92,4242
	Player	'P544______',	2072,2121,2832,2421
	Player	'P545____________',	07A4,3233,3761,3142
	dc.w	2
.tn
	String	'St. Louis'
.ta
	String	'STL'
.tm
	String	'N21__'
.ar
	String	'St. Louis Arena'

TampaBay							;TB, $49FE (94 $4216)
.0
	dc.w	.pld-.0
	dc.w	.pad-.0
	dc.w	.tn-.0
	dc.w	.ls-.0
	dc.w	.sr-.0
	dc.w	.godds-.0
.pad
	incbin	..\Extracted\NHL95\Graphics\Pals\TBh95.pal
	incbin	..\Extracted\NHL95\Graphics\Pals\TBv95.pal
.sr
	dc.w	$1000,$01D7
.godds
	dc.b	196,0
.ls
	dc.b	01,18,17,03,04,14,10,00
	dc.b	01,18,16,10,04,14,03,00
	dc.b	01,17,19,08,03,13,04,00
	dc.b	01,21,20,11,05,12,04,00
	dc.b	01,17,16,03,04,14,10,00
	dc.b	01,18,19,09,05,12,04,00
	dc.b	01,18,19,08,05,04,10,00
	dc.b	01,17,16,10,03,04,14,00
.pld
	Player	'P546_______',	9394,4453,0100,3344
	Player	'P547_________',	0163,3223,0000,2222
	Player	'P548_________',	7792,3324,3D72,3334
	Player	'P549_________',	1944,4434,2A64,4243
	Player	'P550________',	0955,3433,28C3,3043
	Player	'P551_______',	2872,2232,2862,3323
	Player	'P552__________',	1762,2232,4742,3134
	Player	'P553_______',	2473,3333,2A63,4421
	Player	'P554__________',	10A3,2322,2962,3432
	Player	'P555____________',	3462,4232,2962,4531
	Player	'P556_______',	0792,2232,3762,4323
	Player	'P557_______',	1562,3313,1665,3321
	Player	'P558_______',	1492,3343,3663,4233
	Player	'P559______',	8575,5414,1895,4533
	Player	'P560_______',	1291,1111,2821,2415
	Player	'P561________',	23A3,3313,3872,3234
	Player	'P562_________',	4473,2223,3761,3423
	Player	'P563__________',	2292,2332,2762,3222
	Player	'P564_________',	2562,3232,1B60,3322
	Player	'P565_________',	20A2,2122,3851,3324
	Player	'P566__________',	3992,1121,2921,3415
	Player	'P567________',	0382,1121,2911,2414
	dc.w	2
.tn
	String	'Tampa Bay'
.ta
	String	'TB'
.tm
	String	'N22______'
.ar
	String	'Thunderdome'

Toronto								;TOR, $4CB6 (94 $4518)
.0
	dc.w	.pld-.0
	dc.w	.pad-.0
	dc.w	.tn-.0
	dc.w	.ls-.0
	dc.w	.sr-.0
	dc.w	.godds-.0
.pad
	incbin	..\Extracted\NHL95\Graphics\Pals\TORh95.pal
	incbin	..\Extracted\NHL95\Graphics\Pals\TORv95.pal
.sr
	dc.w	$5111,$10E8
.godds
	dc.b	212,0
.ls
	dc.b	01,21,18,09,04,10,15,00
	dc.b	01,17,18,09,04,15,10,00
	dc.b	01,21,19,10,03,16,04,00
	dc.b	01,23,22,11,07,14,04,00
	dc.b	01,17,18,10,04,14,09,00
	dc.b	01,21,19,09,03,15,04,00
	dc.b	01,21,19,10,04,09,15,00
	dc.b	01,17,18,15,07,04,09,00
.pld
	Player	'P568________',	2964,4664,0000,5454
	Player	'P569_________',	0152,3223,0000,3322
	Player	'P570_________',	3273,4332,2862,3222
	Player	'P571________',	9345,4554,4BC4,6043
	Player	'P572_______',	1974,3333,2664,4143
	Player	'P573___________',	2693,3342,3763,4322
	Player	'P574_______',	2593,3243,4773,4141
	Player	'P575__________',	2292,2022,3721,2325
	Player	'P576________',	1783,3436,4774,4444
	Player	'P577___________',	14B3,2534,3A95,5432
	Player	'P578_____',	1073,2232,4B73,4424
	Player	'P579___________',	1883,3232,2962,3321
	Player	'P580________',	2192,2242,3972,4423
	Player	'P581______________',	1664,4423,2594,4241
	Player	'P582________',	2275,5425,2C63,5552
	Player	'P583_______',	1262,2333,2473,4525
	Player	'P584_____',	2363,3332,3562,4123
	Player	'P585_______',	0495,4345,3991,4242
	Player	'P586__________',	1573,3333,1862,3132
	Player	'P587____________',	55A2,2232,3842,3123
	Player	'P588________',	3483,3244,4B71,4442
	Player	'P589_____',	03A3,3142,4871,4424
	Player	'P590____________',	0292,2131,3D70,4433
	Player	'P591_______',	3372,2222,2962,3232
	dc.w	2
.tn
	String	'Toronto'
.ta
	String	'TOR'
.tm
	String	'N23________'
.ar
	String	'Maple Leaf Gardens'

Vancouver							;VAN, $4FA8 (94 $481C)
.0
	dc.w	.pld-.0
	dc.w	.pad-.0
	dc.w	.tn-.0
	dc.w	.ls-.0
	dc.w	.sr-.0
	dc.w	.godds-.0
.pad
	incbin	..\Extracted\NHL95\Graphics\Pals\VANh95.pal
	incbin	..\Extracted\NHL95\Graphics\Pals\VANv95.pal
.sr
	dc.w	$5111,$10E8
.godds
	dc.b	196,0
.ls
	dc.b	01,18,19,07,03,13,14,00
	dc.b	01,24,19,07,03,13,14,00
	dc.b	01,18,23,09,05,14,13,00
	dc.b	01,21,22,08,04,11,13,00
	dc.b	01,18,19,07,03,13,14,00
	dc.b	01,17,23,09,04,14,13,00
	dc.b	01,24,19,13,05,14,09,00
	dc.b	01,18,22,14,06,09,07,00
.pld
	Player	'P592_______',	0164,4444,0000,4444
	Player	'P593________',	3553,3452,0000,2323
	Player	'P594_________',	0755,5432,19C3,5141
	Player	'P595________',	1794,4423,1964,4331
	Player	'P596_________',	3263,3333,3964,3131
	Player	'P597_________',	1572,2132,3771,4222
	Player	'P598___________',	1475,5444,1B62,3344
	Player	'P599_______',	29A3,2233,4982,3326
	Player	'P600______',	0874,4433,3564,4132
	Player	'P601_________',	18C1,1112,3921,2325
	Player	'P602__________',	27A4,3334,5772,4424
	Player	'P603______',	2692,2122,3652,2325
	Player	'P604______',	1056,6625,29C5,4542
	Player	'P605_________',	1693,3444,3CA4,4342
	Player	'P606__________',	2383,3223,2763,2432
	Player	'P607___________',	2082,3223,2874,2423
	Player	'P608________',	0382,2222,2760,3322
	Player	'P609_______',	2174,3443,1B91,4142
	Player	'P610______',	2294,3445,2693,5152
	Player	'P611__________',	0672,2232,3762,3123
	Player	'P612______',	2494,4333,2961,4134
	Player	'P613_______',	44A2,2343,2960,4232
	Player	'P614_______',	0592,2234,3B61,4423
	Player	'P615_________',	0494,4132,4871,3234
	dc.w	2
.tn
	String	'Vancouver'
.ta
	String	'VAN'
.tm
	String	'N24____'
.ar
	String	'General Motors Place'

Winnipeg							;WPG, $528E (94 $4B0A)
.0
	dc.w	.pld-.0
	dc.w	.pad-.0
	dc.w	.tn-.0
	dc.w	.ls-.0
	dc.w	.sr-.0
	dc.w	.godds-.0
.pad
	incbin	..\Extracted\NHL95\Graphics\Pals\WPGh95.pal
	incbin	..\Extracted\NHL95\Graphics\Pals\WPGv95.pal
.sr
	dc.w	$2012,$02E8
.godds
	dc.b	166,0
.ls
	dc.b	01,22,19,08,03,13,04,00
	dc.b	01,22,19,08,03,13,04,00
	dc.b	01,20,21,11,04,15,13,00
	dc.b	01,17,23,09,05,16,13,00
	dc.b	01,22,19,08,03,13,04,00
	dc.b	01,20,21,05,04,15,13,00
	dc.b	01,20,21,08,15,03,13,00
	dc.b	01,22,19,09,05,03,13,00
.pld
	Player	'P616_________',	2963,4443,0000,3333
	Player	'P617________',	0142,2222,0000,2212
	Player	'P618__________',	1075,3443,2793,4142
	Player	'P619________',	2583,3333,3794,3053
	Player	'P620________',	1844,4343,2993,4134
	Player	'P621_______',	3673,3142,4962,5123
	Player	'P622________',	1572,2142,3761,4422
	Player	'P623_________',	0793,3444,4DA4,4434
	Player	'P624_____',	17A3,3242,4B92,4324
	Player	'P625_________',	2163,2122,3963,2522
	Player	'P626__________',	3493,2333,3B73,4232
	Player	'P627________',	3772,2213,2963,2422
	Player	'P628_________',	1365,6524,38C5,5442
	Player	'P629___________',	3843,3232,2863,3231
	Player	'P630__________',	1944,4434,2A94,4242
	Player	'P631____',	2093,2233,3A83,4126
	Player	'P632________',	0672,2213,2931,3322
	Player	'P633__________',	2492,1012,3930,3322
	Player	'P634__________',	2774,3333,3662,4132
	Player	'P635____________',	04B2,2132,4A71,4433
	Player	'P636_______',	0593,2242,4860,4024
	Player	'P637_______',	0394,4325,4981,5434
	Player	'P638________',	2692,2132,3840,4423
	dc.w	2
.tn
	String	'Winnipeg'
.ta
	String	'WPG'
.tm
	String	'N25_'
.ar
	String	'Winnipeg Arena'

Washington							;WSH, $5556 (94 $4DFC)
.0
	dc.w	.pld-.0
	dc.w	.pad-.0
	dc.w	.tn-.0
	dc.w	.ls-.0
	dc.w	.sr-.0
	dc.w	.godds-.0
.pad
	incbin	..\Extracted\NHL95\Graphics\Pals\WSHh95.pal
	incbin	..\Extracted\NHL95\Graphics\Pals\WSHv95.pal
.sr
	dc.w	$2711,$11E7
.godds
	dc.b	164,32
.ls
	dc.b	01,20,18,10,04,05,13,00
	dc.b	01,21,18,10,05,13,04,00
	dc.b	01,20,22,12,04,17,05,00
	dc.b	01,23,19,09,06,07,05,00
	dc.b	01,21,18,07,05,13,04,00
	dc.b	01,20,22,10,04,06,05,00
	dc.b	01,24,18,09,04,05,10,00
	dc.b	01,21,20,12,06,05,10,00
.pld
	Player	'P639_______',	3343,4333,0000,4343
	Player	'P640__________',	3163,3112,0000,3332
	Player	'P641_______',	3542,2102,0000,2222
	Player	'P642_______',	1794,4433,2B95,4042
	Player	'P643______',	9054,5534,28C3,4051
	Player	'P644_______',	3282,2443,4974,4146
	Player	'P645__________',	2083,4433,3793,3042
	Player	'P646_______',	0973,2242,3762,3132
	Player	'P647________',	1084,4333,2D63,4142
	Player	'P648_____________',	0873,3433,3896,4242
	Player	'P649________',	2792,2212,3B52,2415
	Player	'P650__________',	1873,2333,3965,3333
	Player	'P651________',	1264,6433,1794,4432
	Player	'P652____________',	2262,2222,3962,2322
	Player	'P653________',	2162,4232,2942,3512
	Player	'P654_______',	2672,3332,4873,3235
	Player	'P655_____',	1484,3323,1463,3421
	Player	'P656_________',	04B3,3445,5872,4444
	Player	'P657______',	29A3,2232,3D72,3323
	Player	'P658________',	0363,3343,3C72,4333
	Player	'P659___________',	0694,4343,2D62,4142
	Player	'P660_______',	0273,2143,3772,4233
	Player	'P661__________',	3692,2122,3961,2321
	Player	'P662______',	2873,3223,2963,2521
	dc.w	2
.tn
	String	'Washington'
.ta
	String	'WSH'
.tm
	String	'N26_____'
.ar
	String	'US Air Arena'

playoffseats						;Playoff seeding: 32 rows of 16 team numbers (NewPO, MakeTree)
	dc.b	SJ,TOR,LA,DET, VAN,DAL,CGY,CHI, BOS,NYR,MTL,NJ, PIT,PHI,BUF,FLA
	dc.b	EDM,WPG,SJ,DET, LA,TOR,VAN,CHI, QUE,NYI,HFD,TB, OTW,NYR,BOS,NJ
	dc.b	CGY,DAL,ANH,WPG, EDM,STL,SJ,DAL, BOS,NYI,MTL,OTW, PIT,WSH,BUF,NJ
	dc.b	SJ,WPG,LA,STL, VAN,CHI,CGY,DAL, BOS,TB,MTL,NYI, PIT,FLA,BUF,PHI
	dc.b	EDM,TOR,ANH,DET, CGY,DAL,VAN,WPG, QUE,WSH,HFD,NJ, OTW,NYR,BUF,PIT
	dc.b	CGY,WPG,VAN,TOR, LA,CHI,SJ,STL, BOS,FLA,PIT,NYI, HFD,NJ,NYR,BUF
	dc.b	SJ,LA,VAN,CGY, ANH,EDM,TOR,DET, BOS,MTL,PIT,BUF, QUE,HFD,OTW,NYR
	dc.b	DAL,CHI,STL,WPG, DET,SJ,LA,TOR, NJ,WSH,PHI,FLA, NYI,TB,NYR,BOS

	dc.b	VAN,EDM,CGY,ANH, SJ,DAL,LA,CHI, PIT,HFD,BUF,QUE, NYR,TB,NJ,NYI
	dc.b	WPG,DAL,STL,DET, CHI,TOR,VAN,CGY, BOS,NYI,MTL,FLA, PIT,PHI,OTW,QUE
	dc.b	SJ,CHI,TOR,CGY, LA,VAN,DET,DAL, BOS,FLA,NYR,BUF, MTL,PIT,NJ,PHI
	dc.b	DET,SJ,CGY,VAN, TOR,CHI,DAL,STL, NYR,NYI,PIT,WSH, NJ,BUF,BOS,MTL
	dc.b	DET,STL,SJ,DAL, CGY,TOR,VAN,CHI, NYR,MTL,NYI,BOS, PIT,NJ,WSH,BUF
	dc.b	DET,CHI,STL,VAN, DAL,TOR,CGY,SJ, NYR,BUF,MTL,WSH, NYI,PIT,BOS,NJ
	dc.b	DET,VAN,CHI,CGY, STL,TOR,DAL,SJ, NYR,NJ,BUF,BOS, MTL,NYI,WSH,PIT
	dc.b	DET,SJ,VAN,DAL, CHI,STL,CGY,TOR, NYR,PIT,NJ,WSH, BUF,MTL,BOS,NYI

	dc.b	DET,TOR,SJ,CGY, VAN,CHI,DAL,STL, NYR,NYI,PIT,BOS, NJ,BUF,WSH,MTL
	dc.b	DET,STL,TOR,DAL, SJ,VAN,CGY,CHI, NYR,MTL,NYI,WSH, PIT,NJ,BOS,BUF
	dc.b	DET,CHI,STL,CGY, TOR,SJ,DAL,VAN, NYR,BUF,MTL,BOS, NYI,PIT,WSH,NJ
	dc.b	DET,VAN,CHI,DAL, STL,TOR,CGY,SJ, NYR,NJ,BUF,WSH, MTL,NYI,BOS,PIT
	dc.b	DET,SJ,VAN,CGY, CHI,STL,DAL,TOR, NYR,PIT,NJ,BOS, BUF,MTL,WSH,NYI
	dc.b	DET,TOR,SJ,DAL, VAN,CHI,CGY,STL, NYR,NYI,PIT,WSH, NJ,BOS,MTL,BUF
	dc.b	EDM,TOR,SJ,DAL, ANH,CHI,WPG,VAN, TB,MTL,OTW,BOS, PIT,FLA,NYR,QUE
	dc.b	EDM,VAN,TOR,WPG, SJ,ANH,DAL,CHI, TB,QUE,MTL,NYR, OTW,PIT,BOS,FLA

	dc.b	EDM,CHI,VAN,DAL, TOR,SJ,WPG,ANH, TB,FLA,QUE,BOS, MTL,OTW,NYR,PIT
	dc.b	EDM,ANH,CHI,WPG, VAN,TOR,DAL,SJ, TB,PIT,FLA,NYR, QUE,MTL,BOS,OTW
	dc.b	CGY,LA,DET,SJ, VAN,DAL,CHI,ANH, NYI,HFD,BUF,PHI, PIT,QUE,NYR,BOS
	dc.b	CGY,ANH,LA,CHI, DET,VAN,SJ,DAL, NYI,BOS,HFD,NYR, BUF,PIT,PHI,QUE
	dc.b	CGY,DAL,ANH,SJ, LA,DET,CHI,VAN, NYI,QUE,PHI,BOS, HFD,BUF,NYR,PIT
	dc.b	CGY,VAN,DAL,CHI, ANH,LA,SJ,DET, NYI,PIT,QUE,NYR, PHI,HFD,BOS,BUF
	dc.b	CGY,DET,VAN,SJ, DAL,ANH,CHI,LA, NYI,BUF,PIT,BOS, QUE,PHI,NYR,HFD
	dc.b	CGY,LA,DET,CHI, VAN,DAL,SJ,ANH, NYI,HFD,BUF,NYR, PIT,QUE,BOS,PHI
	IF (*-playoffseats)/16<>32
	inform 3,"playoffseats is not 32 rows of 16"
	ENDIF
