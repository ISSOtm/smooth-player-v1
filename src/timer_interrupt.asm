
INCLUDE "hardware.inc"


; Here is how you set up a timer int appropriately
; Yes, it *has* to be the timer int

SECTION "Timer interrupt", ROM0[$50]

TimerHandler:
	; These two registers are used, so they must be saved
	push af
	push hl
	; You don't have to include the code inline,
	; you may have to split the handler in two, especially if using the serial or joypad interrupts
INCLUDE "src/smooth-player/sample_player.asm"
	; After running this code, you will probably want to restore the ROM bank
	ldh a, [hROMBank]
	ld [rROMB0], a
	; Then restore the registers...
	pop hl
	pop af
	; ...and return.
	reti
