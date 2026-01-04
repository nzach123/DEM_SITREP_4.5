# Implementation Plan: CRT Layering Refactor

## Phase 1: Shader Relocation
- [ ] Task: Add `BackBufferCopy` and `ColorRect` (with CRT shader) to `GameOverlay` scene.
- [ ] Task: Remove CRT nodes from individual game scenes (Main Menu, AAR, etc.) or disable them if they are local.
    - *Correction*: If the design requires CRT over *everything*, it moves to `GameOverlay`.
- [ ] Task: Remove `move_child` logic from `GameManager` (if any remains).

## Phase 2: Verification
- [ ] Task: Verify CRT effect applies to the game world AND the Pause Menu.
- [ ] Task: Conductor - User Manual Verification 'CRT Layering' (Protocol in workflow.md)
