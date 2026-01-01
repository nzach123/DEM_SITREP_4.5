# Track Specification: Quiz Audio Typewriter Variation

## Overview
Update the `QuizAudioManager` in the Quiz Scene to support multiple typewriter sound effects for better "arcade" variety. The existing `play_typeon()` method will be renamed to `play_typewriter()` for clarity. The logic will randomly select from three distinct sound nodes (`SFX_typeon01`, `SFX_typeon02`, `SFX_typeon03`) and ensure the same sound is not played twice in a row.

## Functional Requirements
1.  **Refactor Method Name:**
    *   Rename `play_typeon()` to `play_typewriter()`.
    *   Update all callers in the codebase (if any) to use the new method name.

2.  **Multiple Audio Source Support:**
    *   The `QuizAudioManager` script must be updated to reference the three typewriter nodes: `SFX_typeon01`, `SFX_typeon02`, and `SFX_typeon03`.
    *   The `sfx_typewriter` variable should be repurposed (or supplemented) to manage this collection of sounds.

3.  **Randomized "No-Repeat" Logic:**
    *   `play_typewriter()` must select one of the three sounds.
    *   It must track the index of the last played sound to prevent immediate repetition.

4.  **Preserve Polish:**
    *   Apply the existing slight pitch randomization to each typewriter sound played.

5.  **Testing:**
    *   Create a GUT test suite `test_QuizAudioManager.gd` to verify:
        *   Correct initialization of typewriter sounds.
        *   Successful playback through `play_typewriter()`.
        *   Validation of the "no-repeat" randomization constraint over multiple calls.

## Acceptance Criteria
*   [ ] `QuizAudioManager` renamed `play_typeon()` to `play_typewriter()`.
*   [ ] `play_typewriter()` cycles through the three `typeon` SFX nodes.
*   [ ] No sound node plays twice in a row.
*   [ ] `test_QuizAudioManager.gd` passes all tests.
