
INCLUDE "hardware.inc"


SECTION "Header", ROM0[$100]

	ld c, $60
	jr LogoFade

	; Make sure to allocate some space for the header, so no important
	; code gets put there and later overwritten by RGBFIX.
	; RGBFIX is designed to operate over a zero-filled header, so make
	; sure to put zeros regardless of the padding value. (This feature
	; was introduced in RGBDS 0.4.0, but the -MG etc flags were also
	; introduced in that version.)
	ds $150 - @, 0


LogoFade:
    cp $11
    ld a, 0
    jr nz, .notAGB
    ld a, b
    and 1
.notAGB
    ldh [hIsAGB], a

    xor a
    ldh [rAUDENA], a

.fadeLogo
    ld b, 7 ; Number of frames between each logo fade step
.logoWait
    ld a, [rLY]
    cp a, SCRN_Y
    jr nc, .logoWait
.waitVBlank
    ld a, [rLY]
    cp a, SCRN_Y
    jr c, .waitVBlank
    dec b
    jr nz, .logoWait
    ; Shift all colors (fading the logo progressively)
    ld a, c
    rra
    rra
    and $FC ; Ensures a proper rotation and sets Z for final check
    ldh [rBGP], a
    ld c, a
    jr nz, .fadeLogo ; End if the palette is fully blank (flag set from `and $FC`)

    ; xor a
    ldh [rDIV], a

Reset::
    di

    ; Kill sound
    xor a
    ldh [rAUDENA], a

    ; Turn off LCD
.waitVBlank
    ld a, [rLY]
    cp SCRN_Y
    jr c, .waitVBlank
    xor a
    ldh [rLCDC], a


    ; Init VRAM for rPCMxx display
    ld hl, $CCAA
    ld sp, $8810
REPT 8
    push hl
ENDR
    ld sp, wStackBottom

    ; Fill tilemap
    ld hl, _SCRN0
    ld a, $80
    ld bc, SCRN_VX_B * SCRN_Y_B
    rst Memset

    ld a, BANK(SetupPlayback)
    ldh [hROMBank], a
    ld [rROMB0], a

    ld a, LCDCF_ON | LCDCF_BGON
    ldh [rLCDC], a

    xor a
    ldh [rIE], a
    ei ; Delayed until the next instruction: perfectly safe!
    ldh [rIF], a

    jp SetupPlayback


SECTION "Stack", WRAM0

wStack:
	ds 32
wStackBottom:


SECTION "Global HRAM variables", HRAM

hIsAGB:: db
hROMBank:: db
