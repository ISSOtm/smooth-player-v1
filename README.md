# smooth-player-v1

The latest version lives at https://github.com/ISSOtm/smooth-player

To compile the project, make sure you have RGBDS (at least 0.5.0), GNU Make and Python 3, and run `make` within this directory.
Then, you can just run `bin/smooth-player.gb`!

## Code organization

This demo also serves as an example of how to integrate and use smooth-player.

Look at the files `src/playback.asm`, `src/sample.asm`, `src/timer_interrupt.asm`, and the end of `src/utils.asm`.
For the sample conversion, you may be interested in the rule near the bottom of `Makefile`.

This repo is based on [`gb-boilerplate`](https://github.com/ISSOtm/gb-boilerplate) for the general architecture.

## Swapping music tracks

To replace *the best music ever*, included as an example, with your own, follow the following steps:
- Include the music in raw signed 8-bit format under `src/res`, for example `src/res/samples/nyan_cat.raw`.
- Include the sample: `include_sample <Label>, "res/samples/nyan_cat.sample", <size>, <bank>`. `<Label>` is up to you; `<size>` must match the size of the generated `.sample` file; and `<bank>` is the first ROM bank in which the sample will be stored (yes, the sample banks are hardcoded due to technical constraints. Sorry!)
- Replace `RickSample` with `<Label>` in `src/playback.asm`. You can also delete the `include_sample RickSample, ...` line, by the way.
- Compile again, and voilà!

## Making the music loop

Add the lines marked with a `+` to `src/playback.asm`. **Don't add the `+`es themselves!**

```diff
     ldh a, [hIsAGB]
     and a
     play_sample RickSample
     ld a, $77
     ldh [rNR50], a
+    ld hl, rTAC
 .lock
+    bit 2, [hl]
+    jr z, SetupPlayback
     ldh a, [rLY]
     and $04
     rra
```
