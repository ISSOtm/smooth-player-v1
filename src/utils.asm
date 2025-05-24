
INCLUDE "hardware.inc"


SECTION "Memset", ROM0[$08] ; So that it lands on a `rst`

Memset::
	inc b
	inc c
	dec bc
.loop
	ld [hli], a
	dec c
	jr nz, .loop
	dec b
	jr nz, .loop
	ret



; And here is how you include the sample routines

SECTION "Sample routines", ROM0

INCLUDE "src/smooth-player/sample_lib.asm"
