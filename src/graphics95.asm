;	Graphics data, all loaded from the extracted files: player pictures, the rink, sprites, fonts,
;	screen maps and pictures, team logo colors and the arena graphics.

;-------------------------------------------------------------------------------------------------------------
;	Player pictures, the rink, sprites, fonts, screen maps and bitmaps, and the team logos.
; A map starts with its 8-byte header (palette and map offsets), so its tiles are at Label+8.

PicturePalette						;The player picture palette, then the picture of a player with none
									;(DrawMatchupPicture, PlayerCardScreen)
	incbin	..\Extracted\NHL95\Graphics\NoPlayerPicture.map.jim
NoPicSkater2						;Generic skater picture (GetPlayerPicture, hand bit 0 set)
	incbin	..\Extracted\NHL95\Graphics\NoPicSkater2.bin
NoPicSkater1						;Generic skater picture (GetPlayerPicture, hand bit 0 clear)
	incbin	..\Extracted\NHL95\Graphics\NoPicSkater1.bin
NoPicGoalie2						;Generic goalie picture (GetPlayerPicture, hand bit 0 clear)
	incbin	..\Extracted\NHL95\Graphics\NoPicGoalie2.bin
NoPicGoalie1						;Generic goalie picture (GetPlayerPicture, hand bit 0 set)
	incbin	..\Extracted\NHL95\Graphics\NoPicGoalie1.bin
Card001								;Player picture 1 (FeaturedPictures ANH 0)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card001.bin
Card002								;Player picture 2 (FeaturedPictures ANH 4)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card002.bin
Card003								;Player picture 3 (FeaturedPictures ANH 5)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card003.bin
Card004								;Player picture 4 (FeaturedPictures ANH 3)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card004.bin
Card005								;Player picture 5 (FeaturedPictures ANH 2)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card005.bin
Card006								;Player picture 6 (FeaturedPictures ANH 1)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card006.bin
Card007								;Player picture 7 (FeaturedPictures BOS 0)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card007.bin
Card008								;Player picture 8 (FeaturedPictures BOS 4, ASE 4)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card008.bin
Card009								;Player picture 9 (FeaturedPictures BOS 3)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card009.bin
Card010								;Player picture 10 (FeaturedPictures BOS 5)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card010.bin
Card011								;Player picture 11 (FeaturedPictures BOS 1, ASE 1)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card011.bin
Card012								;Player picture 12 (FeaturedPictures BOS 2)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card012.bin
Card013								;Player picture 13 (FeaturedPictures BUF 0)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card013.bin
Card014								;Player picture 14 (FeaturedPictures BUF 4)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card014.bin
Card015								;Player picture 15 (FeaturedPictures BUF 3)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card015.bin
Card016								;Player picture 16 (FeaturedPictures BUF 5, ASE 5)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card016.bin
Card017								;Player picture 17 (FeaturedPictures BUF 1)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card017.bin
Card018								;Player picture 18 (FeaturedPictures BUF 2)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card018.bin
Card019								;Player picture 19 (FeaturedPictures CGY 0)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card019.bin
Card020								;Player picture 20 (FeaturedPictures CGY 4)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card020.bin
Card021								;Player picture 21 (FeaturedPictures CGY 3)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card021.bin
Card022								;Player picture 22 (FeaturedPictures CGY 5)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card022.bin
Card023								;Player picture 23 (FeaturedPictures CGY 1)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card023.bin
Card024								;Player picture 24 (FeaturedPictures CGY 2)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card024.bin
Card025								;Player picture 25 (FeaturedPictures CHI 0)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card025.bin
Card026								;Player picture 26 (FeaturedPictures CHI 4)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card026.bin
Card027								;Player picture 27 (FeaturedPictures CHI 3)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card027.bin
Card028								;Player picture 28 (FeaturedPictures CHI 5)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card028.bin
Card029								;Player picture 29 (FeaturedPictures CHI 2, ASW 2)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card029.bin
Card030								;Player picture 30 (FeaturedPictures CHI 1)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card030.bin
Card031								;Player picture 31 (FeaturedPictures DAL 0)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card031.bin
Card032								;Player picture 32 (FeaturedPictures DAL 4)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card032.bin
Card033								;Player picture 33 (FeaturedPictures DAL 3)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card033.bin
Card034								;Player picture 34 (FeaturedPictures DAL 5)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card034.bin
Card035								;Player picture 35 (FeaturedPictures DAL 1)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card035.bin
Card036								;Player picture 36 (FeaturedPictures DAL 2)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card036.bin
Card037								;Player picture 37 (FeaturedPictures DET 0)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card037.bin
Card038								;Player picture 38 (FeaturedPictures DET 4)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card038.bin
Card039								;Player picture 39 (FeaturedPictures DET 3, ASW 3)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card039.bin
Card040								;Player picture 40 (FeaturedPictures DET 5)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card040.bin
Card041								;Player picture 41 (FeaturedPictures DET 2, ASW 1)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card041.bin
Card042								;Player picture 42 (FeaturedPictures DET 1)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card042.bin
Card043								;Player picture 43 (FeaturedPictures EDM 0)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card043.bin
Card044								;Player picture 44 (FeaturedPictures EDM 4)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card044.bin
Card045								;Player picture 45 (FeaturedPictures EDM 3)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card045.bin
Card046								;Player picture 46 (FeaturedPictures EDM 5)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card046.bin
Card047								;Player picture 47 (FeaturedPictures EDM 1)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card047.bin
Card048								;Player picture 48 (FeaturedPictures EDM 2)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card048.bin
Card049								;Player picture 49 (FeaturedPictures FLA 0)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card049.bin
Card050								;Player picture 50 (FeaturedPictures FLA 4)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card050.bin
Card051								;Player picture 51 (FeaturedPictures FLA 3)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card051.bin
Card052								;Player picture 52 (FeaturedPictures FLA 5)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card052.bin
Card053								;Player picture 53 (FeaturedPictures FLA 1)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card053.bin
Card054								;Player picture 54 (FeaturedPictures FLA 2)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card054.bin
Card055								;Player picture 55 (FeaturedPictures HFD 0)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card055.bin
Card056								;Player picture 56 (FeaturedPictures HFD 4)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card056.bin
Card057								;Player picture 57 (FeaturedPictures HFD 3)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card057.bin
Card058								;Player picture 58 (FeaturedPictures HFD 5)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card058.bin
Card059								;Player picture 59 (FeaturedPictures HFD 1)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card059.bin
Card060								;Player picture 60 (FeaturedPictures HFD 2)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card060.bin
Card061								;Player picture 61 (FeaturedPictures LA 0)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card061.bin
Card062								;Player picture 62 (FeaturedPictures LA 4)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card062.bin
Card063								;Player picture 63 (FeaturedPictures LA 3)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card063.bin
Card064								;Player picture 64 (FeaturedPictures LA 5)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card064.bin
Card065								;Player picture 65 (FeaturedPictures LA 1)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card065.bin
Card066								;Player picture 66 (FeaturedPictures LA 2)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card066.bin
Card067								;Player picture 67 (FeaturedPictures MTL 0, ASE 0)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card067.bin
Card068								;Player picture 68 (FeaturedPictures MTL 4)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card068.bin
Card069								;Player picture 69 (FeaturedPictures MTL 3)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card069.bin
Card070								;Player picture 70 (FeaturedPictures MTL 5)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card070.bin
Card071								;Player picture 71 (FeaturedPictures MTL 2)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card071.bin
Card072								;Player picture 72 (FeaturedPictures MTL 1)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card072.bin
Card073								;Player picture 73 (FeaturedPictures NJ 0)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card073.bin
Card074								;Player picture 74 (FeaturedPictures NJ 4)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card074.bin
Card075								;Player picture 75 (FeaturedPictures NJ 5)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card075.bin
Card076								;Player picture 76 (FeaturedPictures NJ 3)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card076.bin
Card077								;Player picture 77 (FeaturedPictures NJ 2)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card077.bin
Card078								;Player picture 78 (FeaturedPictures NJ 1)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card078.bin
Card079								;Player picture 79 (FeaturedPictures NYI 0)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card079.bin
Card080								;Player picture 80 (FeaturedPictures NYI 4)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card080.bin
Card081								;Player picture 81 (FeaturedPictures NYI 3)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card081.bin
Card082								;Player picture 82 (FeaturedPictures NYI 5)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card082.bin
Card083								;Player picture 83 (FeaturedPictures NYI 2)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card083.bin
Card084								;Player picture 84 (FeaturedPictures NYI 1)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card084.bin
Card085								;Player picture 85 (FeaturedPictures NYR 0)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card085.bin
Card086								;Player picture 86 (FeaturedPictures NYR 4)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card086.bin
Card087								;Player picture 87 (FeaturedPictures NYR 3)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card087.bin
Card088								;Player picture 88 (FeaturedPictures NYR 5)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card088.bin
Card089								;Player picture 89 (FeaturedPictures NYR 1, ASE 2)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card089.bin
Card090								;Player picture 90 (FeaturedPictures NYR 2)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card090.bin
Card091								;Player picture 91 (FeaturedPictures OTW 0)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card091.bin
Card092								;Player picture 92 (FeaturedPictures OTW 5)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card092.bin
Card093								;Player picture 93 (FeaturedPictures OTW 4)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card093.bin
Card094								;Player picture 94 (FeaturedPictures OTW 3)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card094.bin
Card095								;Player picture 95 (FeaturedPictures OTW 1)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card095.bin
Card096								;Player picture 96 (FeaturedPictures OTW 2)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card096.bin
Card097								;Player picture 97 (FeaturedPictures PHI 0)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card097.bin
Card098								;Player picture 98 (FeaturedPictures PHI 4)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card098.bin
Card099								;Player picture 99 (FeaturedPictures PHI 3)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card099.bin
Card100								;Player picture 100 (FeaturedPictures PHI 5)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card100.bin
Card101								;Player picture 101 (FeaturedPictures PHI 1)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card101.bin
Card102								;Player picture 102 (FeaturedPictures PHI 2)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card102.bin
Card103								;Player picture 103 (FeaturedPictures PIT 0)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card103.bin
Card104								;Player picture 104 (FeaturedPictures PIT 4)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card104.bin
Card105								;Player picture 105 (FeaturedPictures PIT 3)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card105.bin
Card106								;Player picture 106 (FeaturedPictures PIT 5)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card106.bin
Card107								;Player picture 107 (FeaturedPictures PIT 1)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card107.bin
Card108								;Player picture 108 (FeaturedPictures PIT 2)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card108.bin
Card109								;Player picture 109 (FeaturedPictures QUE 0)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card109.bin
Card110								;Player picture 110 (FeaturedPictures QUE 4, ASE 3)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card110.bin
Card111								;Player picture 111 (FeaturedPictures QUE 5)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card111.bin
Card112								;Player picture 112 (FeaturedPictures QUE 3)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card112.bin
Card113								;Player picture 113 (FeaturedPictures QUE 2)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card113.bin
Card114								;Player picture 114 (FeaturedPictures QUE 1)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card114.bin
Card115								;Player picture 115 (FeaturedPictures SJ 0)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card115.bin
Card116								;Player picture 116 (FeaturedPictures SJ 4)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card116.bin
Card117								;Player picture 117 (FeaturedPictures SJ 3)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card117.bin
Card118								;Player picture 118 (FeaturedPictures SJ 5)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card118.bin
Card119								;Player picture 119 (FeaturedPictures SJ 1)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card119.bin
Card120								;Player picture 120 (FeaturedPictures SJ 2)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card120.bin
Card121								;Player picture 121 (FeaturedPictures STL 0, ASW 0)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card121.bin
Card122								;Player picture 122 (FeaturedPictures STL 4)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card122.bin
Card123								;Player picture 123 (FeaturedPictures STL 3)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card123.bin
Card124								;Player picture 124 (FeaturedPictures STL 5)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card124.bin
Card125								;Player picture 125 (FeaturedPictures STL 2)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card125.bin
Card126								;Player picture 126 (FeaturedPictures STL 1)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card126.bin
Card127								;Player picture 127 (FeaturedPictures TB 0)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card127.bin
Card128								;Player picture 128 (FeaturedPictures TB 3)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card128.bin
Card129								;Player picture 129 (FeaturedPictures TB 4)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card129.bin
Card130								;Player picture 130 (FeaturedPictures TB 5)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card130.bin
Card131								;Player picture 131 (FeaturedPictures TB 2)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card131.bin
Card132								;Player picture 132 (FeaturedPictures TB 1)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card132.bin
Card133								;Player picture 133 (FeaturedPictures TOR 0)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card133.bin
Card134								;Player picture 134 (FeaturedPictures TOR 4, ASW 4)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card134.bin
Card135								;Player picture 135 (FeaturedPictures TOR 3)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card135.bin
Card136								;Player picture 136 (FeaturedPictures TOR 5)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card136.bin
Card137								;Player picture 137 (FeaturedPictures TOR 1)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card137.bin
Card138								;Player picture 138 (FeaturedPictures TOR 2)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card138.bin
Card139								;Player picture 139 (FeaturedPictures VAN 0)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card139.bin
Card140								;Player picture 140 (FeaturedPictures VAN 4)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card140.bin
Card141								;Player picture 141 (FeaturedPictures VAN 3)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card141.bin
Card142								;Player picture 142 (FeaturedPictures VAN 5, ASW 5)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card142.bin
Card143								;Player picture 143 (FeaturedPictures VAN 1)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card143.bin
Card144								;Player picture 144 (FeaturedPictures VAN 2)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card144.bin
Card145								;Player picture 145 (FeaturedPictures WSH 0)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card145.bin
Card146								;Player picture 146 (FeaturedPictures WSH 4)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card146.bin
Card147								;Player picture 147 (FeaturedPictures WSH 5)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card147.bin
Card148								;Player picture 148 (FeaturedPictures WSH 3)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card148.bin
Card149								;Player picture 149 (FeaturedPictures WSH 2)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card149.bin
Card150								;Player picture 150 (FeaturedPictures WSH 1)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card150.bin
Card151								;Player picture 151 (FeaturedPictures WPG 0)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card151.bin
Card152								;Player picture 152 (FeaturedPictures WPG 4)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card152.bin
Card153								;Player picture 153 (FeaturedPictures WPG 3)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card153.bin
Card154								;Player picture 154 (FeaturedPictures WPG 5)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card154.bin
Card155								;Player picture 155 (FeaturedPictures WPG 2)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card155.bin
Card156								;Player picture 156 (FeaturedPictures WPG 1)
	incbin	..\Extracted\NHL95\Graphics\PlayerCards\Card156.bin
FeaturedPicIdx						;The FeaturedPictures index of the line 1 starters (G, LD, RD, LW, C, RW)
									;of each team (GetPlayerPicture)
	dc.b	0,5,4,3,1,2				;ANH
	dc.b	6,10,11,8,7,9			;BOS
	dc.b	12,16,17,14,13,15		;BUF
	dc.b	18,22,23,20,19,21		;CGY
	dc.b	24,29,28,26,25,27		;CHI
	dc.b	30,34,35,32,31,33		;DAL
	dc.b	36,41,40,38,37,39		;DET
	dc.b	42,46,47,44,43,45		;EDM
	dc.b	48,52,53,50,49,51		;FLA
	dc.b	54,58,59,56,55,57		;HFD
	dc.b	60,64,65,62,61,63		;LA
	dc.b	66,71,70,68,67,69		;MTL
	dc.b	72,77,76,75,73,74		;NJ
	dc.b	78,83,82,80,79,81		;NYI
	dc.b	84,88,89,86,85,87		;NYR
	dc.b	90,94,95,93,92,91		;OTW
	dc.b	96,100,101,98,97,99		;PHI
	dc.b	102,106,107,104,103,105	;PIT
	dc.b	108,113,112,111,109,110	;QUE
	dc.b	114,118,119,116,115,117	;SJ
	dc.b	120,125,124,122,121,123	;STL
	dc.b	126,131,130,127,128,129	;TB
	dc.b	132,136,137,134,133,135	;TOR
	dc.b	138,142,143,140,139,141	;VAN
	dc.b	144,149,148,147,145,146	;WSH
	dc.b	150,155,154,152,151,153	;WPG
	dc.b	66,10,88,109,7,15		;ASE
	dc.b	120,40,28,38,133,141	;ASW
FeaturedPictures					;The 160 player pictures (GetPlayerPicture)
	IF (FeaturedPictures-FeaturedPicIdx)/6<>NumTeams
	inform 3,"FeaturedPicIdx does not match the team count"
	ENDIF
	dc.l	Card001,Card002,Card003,Card004
	dc.l	Card005,Card006,Card007,Card008
	dc.l	Card009,Card010,Card011,Card012
	dc.l	Card013,Card014,Card015,Card016
	dc.l	Card017,Card018,Card019,Card020
	dc.l	Card021,Card022,Card023,Card024
	dc.l	Card025,Card026,Card027,Card028
	dc.l	Card029,Card030,Card031,Card032
	dc.l	Card033,Card034,Card035,Card036
	dc.l	Card037,Card038,Card039,Card040
	dc.l	Card041,Card042,Card043,Card044
	dc.l	Card045,Card046,Card047,Card048
	dc.l	Card049,Card050,Card051,Card052
	dc.l	Card053,Card054,Card055,Card056
	dc.l	Card057,Card058,Card059,Card060
	dc.l	Card061,Card062,Card063,Card064
	dc.l	Card065,Card066,Card067,Card068
	dc.l	Card069,Card070,Card071,Card072
	dc.l	Card073,Card074,Card075,Card076
	dc.l	Card077,Card078,Card079,Card080
	dc.l	Card081,Card082,Card083,Card084
	dc.l	Card085,Card086,Card087,Card088
	dc.l	Card089,Card090,Card091,Card092
	dc.l	Card093,Card094,Card095,Card096
	dc.l	Card097,Card098,Card099,Card100
	dc.l	Card101,Card102,Card103,Card104
	dc.l	Card105,Card106,Card107,Card108
	dc.l	Card109,Card110,Card111,Card112
	dc.l	Card113,Card114,Card115,Card116
	dc.l	Card117,Card118,Card119,Card120
	dc.l	Card121,Card122,Card123,Card124
	dc.l	Card125,Card126,Card127,Card128
	dc.l	Card129,Card130,Card131,Card132
	dc.l	Card133,Card134,Card135,Card136
	dc.l	Card137,Card138,Card139,Card140
	dc.l	Card141,Card142,Card143,Card144
	dc.l	Card145,Card146,Card147,Card148
	dc.l	Card149,Card150,Card151,Card152
	dc.l	Card153,Card154,Card155,Card156
	dc.l	NoPicSkater2,NoPicSkater1,NoPicGoalie1,NoPicGoalie2
Rinktilelist						;The ice rink map; Rinktilelist+8 = the rink tiles
	incbin	..\Extracted\NHL95\Graphics\Rinktilelist.map.jim
Sprites								;The sprite header: long offsets from here and (to frameSprData), then a
									;word
	incbin	..\Extracted\NHL95\Graphics\Sprites.bin
Spritetiles							;The sprite tiles
	incbin	..\Extracted\NHL95\Graphics\Spritetiles.bin
frameSprData
	incbin	..\Extracted\NHL95\Graphics\frameSprData.bin
HotList								;The hot spot byte pair of each frame
	incbin	..\Extracted\NHL95\Graphics\HotSpotList.bin
RosterFont							;Data
	incbin	..\Extracted\NHL95\Graphics\RosterFont.bin
SmallFontMap						;The SmallFontMap map
	incbin	..\Extracted\NHL95\Graphics\SmallFontMap.map.jim
SmallFontMap2						;The SmallFontMap2 map
	incbin	..\Extracted\NHL95\Graphics\SmallFontMap2.map.jim
PauseBgBitmap						;The PauseBgBitmap map
	incbin	..\Extracted\NHL95\Graphics\PauseBgBitmap.map.jim
PeriodNumberBitmap					;The PeriodNumberBitmap map
	incbin	..\Extracted\NHL95\Graphics\PeriodNumberBitmap.map.jim
TabBitmap							;The TabBitmap map
	incbin	..\Extracted\NHL95\Graphics\TabBitmap.map.jim
PauseFontMap						;The PauseFontMap map
	incbin	..\Extracted\NHL95\Graphics\PauseFontMap.map.jim
ClockDigitsBitmap					;The ClockDigitsBitmap map
	incbin	..\Extracted\NHL95\Graphics\ClockDigitsBitmap.map.jim
RosterBitmap						;The RosterBitmap map
	incbin	..\Extracted\NHL95\Graphics\RosterBitmap.map.jim
TeamblocksWide equ 11				;banner map sizes: two rows per team
TeamblocksRows equ 56
PauseTeamBlocksWide equ 12
PauseTeamBlocksRows equ 56
TeamBitmapsWide equ 11
TeamBitmapsRows equ 56
	IF TeamblocksWide<>11
	inform 3,"Teamblocksmap is not 11 tiles wide"
	ENDIF
	IF TeamblocksRows/2<>NumTeams
	inform 3,"Teamblocksmap does not match the team count"
	ENDIF
	IF PauseTeamBlocksWide<>12
	inform 3,"PauseTeamBlocksMap is not 12 tiles wide"
	ENDIF
	IF PauseTeamBlocksRows/2<>NumTeams
	inform 3,"PauseTeamBlocksMap does not match the team count"
	ENDIF
	IF TeamBitmapsWide<>11
	inform 3,"TeamBitmaps is not 11 tiles wide"
	ENDIF
	IF TeamBitmapsRows/2<>NumTeams
	inform 3,"TeamBitmaps does not match the team count"
	ENDIF
Teamblocksmap						;The Teamblocksmap map
	incbin	..\Extracted\NHL95\Graphics\Teamblocksmap.map.jim
PauseTeamBlocksMap					;The PauseTeamBlocksMap map
	incbin	..\Extracted\NHL95\Graphics\PauseTeamBlocksMap.map.jim
FaceOffMap							;The face-off map; +8 the tiles
	incbin	..\Extracted\NHL95\Graphics\FaceOffMap.map.jim
FaceoffTiles	equ	FaceOffMap		;the same address
FaceOffSprites						;The face-off sprites; +8 the tiles
	incbin	..\Extracted\NHL95\Graphics\FaceOffSprites.map.jim
FaceoffTiles2	equ	FaceOffSprites	;the same address
FramerMap							;The FramerMap map
	incbin	..\Extracted\NHL95\Graphics\FramerMap.map.jim
Framermap2							;The Framermap2 map
	incbin	..\Extracted\NHL95\Graphics\Framermap2.map.jim
EnergyBarMap						;The EnergyBarMap map
	incbin	..\Extracted\NHL95\Graphics\EnergyBarMap.map.jim
EASportsMap							;The EASportsMap map
	incbin	..\Extracted\NHL95\Graphics\EASportsMap.map.jim
RefTiles							;The RefTiles map
	incbin	..\Extracted\NHL95\Graphics\RefTiles.map.jim
RefTilesHor							;The RefTilesHor map
	incbin	..\Extracted\NHL95\Graphics\RefTilesHor.map.jim
SetupFont							;The SetupFont map
	incbin	..\Extracted\NHL95\Graphics\SetupFont.map.jim
SetupBgMap2							;The SetupBgMap2 map
	incbin	..\Extracted\NHL95\Graphics\SetupBgMap2.map.jim
SetupBgMap1							;The SetupBgMap1 map
	incbin	..\Extracted\NHL95\Graphics\SetupBgMap1.map.jim
TeamBitmaps							;The TeamBitmaps map
	incbin	..\Extracted\NHL95\Graphics\TeamBitmaps.map.jim
BigFontMap3							;The BigFontMap3 map
	incbin	..\Extracted\NHL95\Graphics\BigFontMap3.map.jim
BigFontMap							;The BigFontMap map
	incbin	..\Extracted\NHL95\Graphics\BigFontMap.map.jim
BigFontMap2							;The BigFontMap2 map
	incbin	..\Extracted\NHL95\Graphics\BigFontMap2.map.jim
RevRinkTilelist						;Data
	incbin	..\Extracted\NHL95\Graphics\RevRinkTilelist.bin
ReplayMap							;The ReplayMap map
	incbin	..\Extracted\NHL95\Graphics\ReplayMap.map.jim
ReplayIconMap						;The ReplayIconMap map
	incbin	..\Extracted\NHL95\Graphics\ReplayIconMap.map.jim
HiScoreBgMap						;The HiScoreBgMap map
	incbin	..\Extracted\NHL95\Graphics\HiScoreBgMap.map.jim
HiScoreImg							;The HiScoreImg map
	incbin	..\Extracted\NHL95\Graphics\HiScoreImg.map.jim
ControllerBgMap						;The ControllerBgMap map
	incbin	..\Extracted\NHL95\Graphics\ControllerBgMap.map.jim
GamesTodayLogoMap					;The GamesTodayLogoMap map
	incbin	..\Extracted\NHL95\Graphics\GamesTodayLogoMap.map.jim
GamesTodayMap1						;The GamesTodayMap1 map
	incbin	..\Extracted\NHL95\Graphics\GamesTodayMap1.map.jim
GamesTodayMap2						;The GamesTodayMap2 map
	incbin	..\Extracted\NHL95\Graphics\GamesTodayMap2.map.jim
GamesTodayMap3						;The GamesTodayMap3 map
	incbin	..\Extracted\NHL95\Graphics\GamesTodayMap3.map.jim
CalendarBgMap						;The CalendarBgMap map
	incbin	..\Extracted\NHL95\Graphics\CalendarBgMap.map.jim
CalOpponentMap						;The CalOpponentMap map
	incbin	..\Extracted\NHL95\Graphics\CalOpponentMap.map.jim
CalDayMap							;The CalDayMap map
	incbin	..\Extracted\NHL95\Graphics\CalDayMap.map.jim
CalMonthMap							;The CalMonthMap map
	incbin	..\Extracted\NHL95\Graphics\CalMonthMap.map.jim
CalCheckMap							;Data
	incbin	..\Extracted\NHL95\Graphics\CalCheckMap.bin
CalResultMap						;The CalResultMap map
	incbin	..\Extracted\NHL95\Graphics\CalResultMap.map.jim
ControllerTitleMap					;The ControllerTitleMap map
	incbin	..\Extracted\NHL95\Graphics\ControllerTitleMap.map.jim
PadCursorMap						;The PadCursorMap map
	incbin	..\Extracted\NHL95\Graphics\PadCursorMap.map.jim
PadIconMap1							;The PadIconMap1 map
	incbin	..\Extracted\NHL95\Graphics\PadIconMap1.map.jim
PadIconMap2							;The PadIconMap2 map
	incbin	..\Extracted\NHL95\Graphics\PadIconMap2.map.jim
PadIconMap3							;The PadIconMap3 map
	incbin	..\Extracted\NHL95\Graphics\PadIconMap3.map.jim
PadIconMap4							;The PadIconMap4 map
	incbin	..\Extracted\NHL95\Graphics\PadIconMap4.map.jim
PlayerStatsBgMap					;The PlayerStatsBgMap map
	incbin	..\Extracted\NHL95\Graphics\PlayerStatsBgMap.map.jim
PlayerStatsTitleMap					;The PlayerStatsTitleMap map
	incbin	..\Extracted\NHL95\Graphics\PlayerStatsTitleMap.map.jim
PeriodStatsMap						;The PeriodStatsMap map
	incbin	..\Extracted\NHL95\Graphics\PeriodStatsMap.map.jim
HighlightsBgMap						;The HighlightsBgMap map
	incbin	..\Extracted\NHL95\Graphics\HighlightsBgMap.map.jim
WaitBoxMap							;The WaitBoxMap map
	incbin	..\Extracted\NHL95\Graphics\WaitBoxMap.map.jim
LineEditorBgMap						;The LineEditorBgMap map
	incbin	..\Extracted\NHL95\Graphics\LineEditorBgMap.map.jim
Screen6Tiles1	equ	LineEditorBgMap+8	;the tiles
PlayerSelectMap2					;The PlayerSelectMap2 map
	incbin	..\Extracted\NHL95\Graphics\PlayerSelectMap2.map.jim
Screen6Tiles2	equ	PlayerSelectMap2+8	;the tiles
PlayerSelectMap1					;The PlayerSelectMap1 map
	incbin	..\Extracted\NHL95\Graphics\PlayerSelectMap1.map.jim
CreateBgMap							;The CreateBgMap map
	incbin	..\Extracted\NHL95\Graphics\CreateBgMap.map.jim
TradeBgMap							;The TradeBgMap map
	incbin	..\Extracted\NHL95\Graphics\TradeBgMap.map.jim
AwardsBgMap							;The AwardsBgMap map
	incbin	..\Extracted\NHL95\Graphics\AwardsBgMap.map.jim
FinalistsPanelMap					;The FinalistsPanelMap map
	incbin	..\Extracted\NHL95\Graphics\FinalistsPanelMap.map.jim
WinnerPanelMap						;The WinnerPanelMap map
	incbin	..\Extracted\NHL95\Graphics\WinnerPanelMap.map.jim
HartPic								;The HartPic map
	incbin	..\Extracted\NHL95\Graphics\HartPic.map.jim
NorrisPic							;The NorrisPic map
	incbin	..\Extracted\NHL95\Graphics\NorrisPic.map.jim
VezinaPic							;The VezinaPic map
	incbin	..\Extracted\NHL95\Graphics\VezinaPic.map.jim
ArtRossPic							;The ArtRossPic map
	incbin	..\Extracted\NHL95\Graphics\ArtRossPic.map.jim
SelkePic							;The SelkePic map
	incbin	..\Extracted\NHL95\Graphics\SelkePic.map.jim
JenningsPic							;The JenningsPic map
	incbin	..\Extracted\NHL95\Graphics\JenningsPic.map.jim
PresidentsPic						;The PresidentsPic map
	incbin	..\Extracted\NHL95\Graphics\PresidentsPic.map.jim
ConnSmythePic						;The ConnSmythePic map
	incbin	..\Extracted\NHL95\Graphics\ConnSmythePic.map.jim
PearsonPic							;The PearsonPic map
	incbin	..\Extracted\NHL95\Graphics\PearsonPic.map.jim
EASNmap								;The EASNmap map
	incbin	..\Extracted\NHL95\Graphics\EASNmap.map.jim
GMDecisionMap						;The GMDecisionMap map
	incbin	..\Extracted\NHL95\Graphics\GMDecisionMap.map.jim
FreeAgentMap2						;The FreeAgentMap2 map
	incbin	..\Extracted\NHL95\Graphics\FreeAgentMap2.map.jim
FreeAgentMap1						;The FreeAgentMap1 map
	incbin	..\Extracted\NHL95\Graphics\FreeAgentMap1.map.jim
TradeAdvantageMap2					;The TradeAdvantageMap2 map
	incbin	..\Extracted\NHL95\Graphics\TradeAdvantageMap2.map.jim
TradeAdvantageMap1					;The TradeAdvantageMap1 map
	incbin	..\Extracted\NHL95\Graphics\TradeAdvantageMap1.map.jim
NameEntryBgMap						;The NameEntryBgMap map
	incbin	..\Extracted\NHL95\Graphics\NameEntryBgMap.map.jim
Arrowsmap							;The Arrowsmap map
	incbin	..\Extracted\NHL95\Graphics\Arrowsmap.map.jim
ScoutMap							;The ScoutMap map
	incbin	..\Extracted\NHL95\Graphics\ScoutMap.map.jim
PlayoffSprite						;The PlayoffSprite map
	incbin	..\Extracted\NHL95\Graphics\PlayoffSprite.map.jim
ScoutReportMap						;The ScoutReportMap map
	incbin	..\Extracted\NHL95\Graphics\ScoutReportMap.map.jim
HotIconMap							;The HotIconMap map
	incbin	..\Extracted\NHL95\Graphics\HotIconMap.map.jim
ColdIconMap							;The ColdIconMap map
	incbin	..\Extracted\NHL95\Graphics\ColdIconMap.map.jim
RonBarrMap							;The RonBarrMap map
	incbin	..\Extracted\NHL95\Graphics\RonBarrMap.map.jim
Crowdframelist						;The crowd sprites; +8 the tiles
	incbin	..\Extracted\NHL95\Graphics\Crowdframelist.map.jim
TitleScreenImg						;The TitleScreenImg map
	incbin	..\Extracted\NHL95\Graphics\TitleScreenImg.map.jim
TitleImg							;The TitleImg map
	incbin	..\Extracted\NHL95\Graphics\TitleImg.map.jim
StanleyCupImg						;The StanleyCupImg map
	incbin	..\Extracted\NHL95\Graphics\StanleyCupImg.map.jim
CupSprites							;The CupSprites map
	incbin	..\Extracted\NHL95\Graphics\CupSprites.map.jim
logoANH								;Team logo (TeamLogoBitmaps)
	incbin	..\Extracted\NHL95\Graphics\logoANA.map.jim
logoBOS								;Team logo (TeamLogoBitmaps)
	incbin	..\Extracted\NHL95\Graphics\logoBOS.map.jim
logoBUF								;Team logo (TeamLogoBitmaps)
	incbin	..\Extracted\NHL95\Graphics\logoBUF.map.jim
logoCGY								;Team logo (TeamLogoBitmaps)
	incbin	..\Extracted\NHL95\Graphics\logoCGY.map.jim
logoCHI								;Team logo (TeamLogoBitmaps)
	incbin	..\Extracted\NHL95\Graphics\logoCHI.map.jim
logoDET								;Team logo (TeamLogoBitmaps)
	incbin	..\Extracted\NHL95\Graphics\logoDET.map.jim
logoEDM								;Team logo (TeamLogoBitmaps)
	incbin	..\Extracted\NHL95\Graphics\logoEDM.map.jim
logoFLA								;Team logo (TeamLogoBitmaps)
	incbin	..\Extracted\NHL95\Graphics\logoFLA.map.jim
logoHFD								;Team logo (TeamLogoBitmaps)
	incbin	..\Extracted\NHL95\Graphics\logoHFD.map.jim
logoNYI								;Team logo (TeamLogoBitmaps)
	incbin	..\Extracted\NHL95\Graphics\logoNYI.map.jim
logoLA								;Team logo (TeamLogoBitmaps)
	incbin	..\Extracted\NHL95\Graphics\logoLA.map.jim
logoDAL								;Team logo (TeamLogoBitmaps)
	incbin	..\Extracted\NHL95\Graphics\logoDAL.map.jim
logoMTL								;Team logo (TeamLogoBitmaps)
	incbin	..\Extracted\NHL95\Graphics\logoMTL.map.jim
logoNJ								;Team logo (TeamLogoBitmaps)
	incbin	..\Extracted\NHL95\Graphics\logoNJ.map.jim
logoNYR								;Team logo (TeamLogoBitmaps)
	incbin	..\Extracted\NHL95\Graphics\logoNYR.map.jim
logoOTW								;Team logo (TeamLogoBitmaps)
	incbin	..\Extracted\NHL95\Graphics\logoOTW.map.jim
logoPHI								;Team logo (TeamLogoBitmaps)
	incbin	..\Extracted\NHL95\Graphics\logoPHI.map.jim
logoPIT								;Team logo (TeamLogoBitmaps)
	incbin	..\Extracted\NHL95\Graphics\logoPIT.map.jim
logoQUE								;Team logo (TeamLogoBitmaps)
	incbin	..\Extracted\NHL95\Graphics\logoQUE.map.jim
logoSJ								;Team logo (TeamLogoBitmaps)
	incbin	..\Extracted\NHL95\Graphics\logoSJ.map.jim
logoSTL								;Team logo (TeamLogoBitmaps)
	incbin	..\Extracted\NHL95\Graphics\logoSTL.map.jim
logoTB								;Team logo (TeamLogoBitmaps)
	incbin	..\Extracted\NHL95\Graphics\logoTB.map.jim
logoTOR								;Team logo (TeamLogoBitmaps)
	incbin	..\Extracted\NHL95\Graphics\logoTOR.map.jim
logoVAN								;Team logo (TeamLogoBitmaps)
	incbin	..\Extracted\NHL95\Graphics\logoVAN.map.jim
logoWSH								;Team logo (TeamLogoBitmaps)
	incbin	..\Extracted\NHL95\Graphics\logoWSH.map.jim
logoWPG								;Team logo (TeamLogoBitmaps)
	incbin	..\Extracted\NHL95\Graphics\logoWPG.map.jim
logoASE								;Team logo (TeamLogoBitmaps)
	incbin	..\Extracted\NHL95\Graphics\logoASE.map.jim
logoASW								;Team logo (TeamLogoBitmaps)
	incbin	..\Extracted\NHL95\Graphics\logoASW.map.jim

;-------------------------------------------------------------------------------------------------------------
;	Team logo palettes, one per team in TeamList order.

TeamLogoPalettes					;Team logo palettes, 16 colors per team (DrawMatchupLogo, NameEntryScreen,
									;DrawTeamBitmap)
	incbin	..\Extracted\NHL95\Graphics\Pals\MatchupPalANHA.pal	;ANH, 94 file, same bytes
	incbin	..\Extracted\NHL95\Graphics\Pals\TeamLogoPalBOS.pal	;BOS, 94 file, same bytes
	incbin	..\Extracted\NHL95\Graphics\Pals\MatchupPalBUFA.pal	;BUF, 94 file, same bytes
	incbin	..\Extracted\NHL95\Graphics\Pals\MatchupPalCGYA.pal	;CGY, 94 file, same bytes
	incbin	..\Extracted\NHL95\Graphics\Pals\MatchupPalCHIA.pal	;CHI, 94 file, same bytes
	incbin	..\Extracted\NHL95\Graphics\Pals\MatchupPalDALA95.pal	;DAL, new palette
	incbin	..\Extracted\NHL95\Graphics\Pals\MatchupPalDETA.pal	;DET, 94 file, same bytes
	incbin	..\Extracted\NHL95\Graphics\Pals\MatchupPalEDMA.pal	;EDM, 94 file, same bytes
	incbin	..\Extracted\NHL95\Graphics\Pals\TeamLogoPalFLA.pal	;FLA, 94 file, same bytes
	incbin	..\Extracted\NHL95\Graphics\Pals\TeamLogoPalHFD.pal	;HFD, 94 file, same bytes
	incbin	..\Extracted\NHL95\Graphics\Pals\MatchupPalLAA.pal	;LA, 94 file, same bytes
	incbin	..\Extracted\NHL95\Graphics\Pals\MatchupPalMTLA.pal	;MTL, 94 file, same bytes
	incbin	..\Extracted\NHL95\Graphics\Pals\MatchupPalNJA.pal	;NJ, 94 file, same bytes
	incbin	..\Extracted\NHL95\Graphics\Pals\MatchupPalNYIA.pal	;NYI, 94 file, same bytes
	incbin	..\Extracted\NHL95\Graphics\Pals\MatchupPalNYRA.pal	;NYR, 94 file, same bytes
	incbin	..\Extracted\NHL95\Graphics\Pals\MatchupPalOTWA.pal	;OTW, 94 file, same bytes
	incbin	..\Extracted\NHL95\Graphics\Pals\MatchupPalPHIA.pal	;PHI, 94 file, same bytes
	incbin	..\Extracted\NHL95\Graphics\Pals\MatchupPalPITA.pal	;PIT, 94 file, same bytes
	incbin	..\Extracted\NHL95\Graphics\Pals\MatchupPalQUEA.pal	;QUE, 94 file, same bytes
	incbin	..\Extracted\NHL95\Graphics\Pals\TeamLogoPalSJ.pal	;SJ, 94 file, same bytes
	incbin	..\Extracted\NHL95\Graphics\Pals\MatchupPalSTLA.pal	;STL, 94 file, same bytes
	incbin	..\Extracted\NHL95\Graphics\Pals\MatchupPalTBA.pal	;TB, 94 file, same bytes
	incbin	..\Extracted\NHL95\Graphics\Pals\MatchupPalTORA.pal	;TOR, 94 file, same bytes
	incbin	..\Extracted\NHL95\Graphics\Pals\MatchupPalVANA.pal	;VAN, 94 file, same bytes
	incbin	..\Extracted\NHL95\Graphics\Pals\MatchupPalWSHA.pal	;WSH, 94 file, same bytes
	incbin	..\Extracted\NHL95\Graphics\Pals\MatchupPalWPGA.pal	;WPG, 94 file, same bytes
	incbin	..\Extracted\NHL95\Graphics\Pals\MatchupPalASEA95.pal	;ASE, new palette
	incbin	..\Extracted\NHL95\Graphics\Pals\MatchupPalASWA95.pal	;ASW, new palette
	IF (*-TeamLogoPalettes)/32<>NumTeams
	inform 3,"TeamLogoPalettes does not match the team count"
	ENDIF

;-------------------------------------------------------------------------------------------------------------
;	The home team arena graphics, one block per team.

ArenaGfxBank						;LoadHomeTeamGfx: one block of $30A bytes per team (TeamGfxList)
	incbin	..\Extracted\NHL95\Graphics\ArenaGfx\ArenaGfxANH.bin
	incbin	..\Extracted\NHL95\Graphics\ArenaGfx\ArenaGfxBUF.bin
	incbin	..\Extracted\NHL95\Graphics\ArenaGfx\ArenaGfxCGY.bin
	incbin	..\Extracted\NHL95\Graphics\ArenaGfx\ArenaGfxCHI.bin
	incbin	..\Extracted\NHL95\Graphics\ArenaGfx\ArenaGfxDAL.bin
	incbin	..\Extracted\NHL95\Graphics\ArenaGfx\ArenaGfxDET.bin
	incbin	..\Extracted\NHL95\Graphics\ArenaGfx\ArenaGfxEDM.bin
	incbin	..\Extracted\NHL95\Graphics\ArenaGfx\ArenaGfxFLA.bin
	incbin	..\Extracted\NHL95\Graphics\ArenaGfx\ArenaGfxHFD.bin
	incbin	..\Extracted\NHL95\Graphics\ArenaGfx\ArenaGfxLA.bin
	incbin	..\Extracted\NHL95\Graphics\ArenaGfx\ArenaGfxMTL.bin
	incbin	..\Extracted\NHL95\Graphics\ArenaGfx\ArenaGfxNJ.bin
	incbin	..\Extracted\NHL95\Graphics\ArenaGfx\ArenaGfxNYI.bin
	incbin	..\Extracted\NHL95\Graphics\ArenaGfx\ArenaGfxNYR.bin
	incbin	..\Extracted\NHL95\Graphics\ArenaGfx\ArenaGfxOTW.bin
	incbin	..\Extracted\NHL95\Graphics\ArenaGfx\ArenaGfxPHI.bin
	incbin	..\Extracted\NHL95\Graphics\ArenaGfx\ArenaGfxPIT.bin
	incbin	..\Extracted\NHL95\Graphics\ArenaGfx\ArenaGfxQUE.bin
	incbin	..\Extracted\NHL95\Graphics\ArenaGfx\ArenaGfxSJ.bin
	incbin	..\Extracted\NHL95\Graphics\ArenaGfx\ArenaGfxSTL.bin
	incbin	..\Extracted\NHL95\Graphics\ArenaGfx\ArenaGfxTB.bin
	incbin	..\Extracted\NHL95\Graphics\ArenaGfx\ArenaGfxTOR.bin
	incbin	..\Extracted\NHL95\Graphics\ArenaGfx\ArenaGfxVAN.bin
	incbin	..\Extracted\NHL95\Graphics\ArenaGfx\ArenaGfxWSH.bin
	incbin	..\Extracted\NHL95\Graphics\ArenaGfx\ArenaGfxWPG.bin
	incbin	..\Extracted\NHL95\Graphics\ArenaGfx\ArenaGfxBOS.bin
	incbin	..\Extracted\NHL95\Graphics\ArenaGfx\ArenaGfxASEASW.bin
