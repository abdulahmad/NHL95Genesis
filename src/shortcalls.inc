;	Short-range targets. The retail 95 code has no absolute short jsr / jmp (x).w calls into ROM; its
;	one short-range reference outside a file is bra.w Begin at the end of the startup code in main95.asm.
;
;	If added data pushes Begin out of that branch's reach, the build reports it here with the fix. Emits
;	no bytes. See docs/EXPANDING_THE_ROM.md.

	IF Begin>$7FFF
		inform	2,"SHORTCALL Begin is past $7FFF (reached with bra.w from main95.asm). Fix: put the new data after the 2MB fill, or change that branch to jmp (Begin).l. See docs/EXPANDING_THE_ROM.md"
	ENDIF
