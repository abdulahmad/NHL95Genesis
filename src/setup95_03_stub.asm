;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
;	setup95_03 segment stub. Retail $0A00D6-$0A0B3D.
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; region code
	org	$A00D6

; includes for stubs to replace removed code
	include	stubinc\ports.inc	;IO_* / VDP_* ports
	include	stubinc\equals.inc	;VDP status bits
	include	ram95.asm		;RAM map

; External addresses outside $0A00D6-$0A0B3D, read from lst/nhl95.bin.
TeamList = $772			;main95
dobitmap = $79A3C		;video95_01
printz = $7C810			;video95_03
print = $7C822			;video95_03
eraser = $7C8CC			;video95_03
ReadAttributeNibbleD7 = $7CB60	;video95_03
FormatPlayerName = $7CDC2	;video95_03
DoDMA_nd2 = $7D35E		;video95_03
GetRosterId = $96454		;trade95
GetCreatedName = $96494		;trade95
GetLogName = $9B50E		;cards95_01
SortHotColdStarters = $A0042	;scout95
NoPicSkater2 = $A1E90		;graphics95_01
NoPicSkater1 = $A21FA		;graphics95_01
NoPicGoalie2 = $A2564		;graphics95_01
NoPicGoalie1 = $A28CE		;graphics95_01
FeaturedPicIdx = $C4754		;graphics95_01
FeaturedPictures = $C47FC	;graphics95_01
HotIconMap = $18A5C6		;graphics95_01
ColdIconMap = $18A78C		;graphics95_01

; Main segment code
	include	setup95_03.asm
