
INCLUDE "hardware.inc"


; Here is how you set up sample playback

INCLUDE "src/smooth-player/sample_macros.asm" ; For `play_sample`


SECTION "Sample playback", ROM0

SetupPlayback::
    ldh a, [hIsAGB]
    and a
    play_sample RickSample
    ld a, $77
    ldh [rNR50], a
.lock
    ldh a, [rLY]
    and $04
    rra
    rra
    add a, $76
    ld c, a
    ldh a, [c]
    ldh [rBGP], a
    jr .lock
