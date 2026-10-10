;	NHL 95 cartridge header, $100-$1FF (94 sega\SegaIDTable94.asm). Included by main95.asm; no org here, main95 is at $100 when it
;	includes this. The checksum word is the retail value with CHECKSUM=1 and REV=0.

;					Data	  	No.		Address	Description
	dc.b	'SEGA GENESIS    '	; 01	$100	Sega Genesis ID (16 bytes)
	dc.b	'(C)T-50 1994.JUL'	; 02	$110	company ID / release date (YYYY.MMM) (16 bytes). 94: 1993.JUL
	dc.b	'NHL ''95                                         '	; 03	$120	game title for US market (48 bytes)
	dc.b	'NHL ''95                                         '	; 04	$150	game title for Japanese market (48 bytes)
	dc.b	'GM T-50856 -00'	; 05	$180	cartridge cat., product no., version no. (14 bytes). 94: T-50656
	IF CHECKSUM=1 ; Security check enabled
		IF REV=0 ; RETAIL
			dc.w	$3C61		; 06	$18E	check sum data (installed by checsum program) (2 bytes)
		ELSE ; REV A
			dc.w	$0000		; 06	$18E	check sum data (installed by checsum program) (2 bytes)
		ENDIF
	ELSE ; Security check disabled
		dc.w	$0000			; 06	$18E	check sum data (installed by checsum program) (2 bytes)
	ENDIF
	dc.b	'J               '	; 07	$190	I/O peripheral info. (J=Control Pad) (16 bytes)
	dc.l	$00000000,$001FFFFF	; 08	$1A0	cartridge size (start and end address) (8 bytes). 2 MB (94: $FFFFF)
	dc.l	$00FF0000,$00FFFFFF	; 09	$1A8	RAM size (start and end address) (8 bytes)
	dc.b	'RA',$F8,$20		; 10	$1B0	external RAM info. (12 bytes): backup RAM, odd bytes
	dc.l	$00200001,$0020FFFF	; 		$1B4	backup RAM start and end address (94: $203FFF)
	dc.b	'            '		; 11	$1BC	modem info. (12 bytes)
	dc.b	'                                        '	; 12	$1C8	inhibit to use (40 bytes)
CountryCode	;The region lock (CHECK_VDP) reads these letters
	dc.b	'EUJ             '	; 13	$1F0	contry code for release (16 bytes). E = Europe, U = USA, J = Japan (94: UE)
