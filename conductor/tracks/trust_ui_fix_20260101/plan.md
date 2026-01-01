# Implementation Plan - PublicTrustSystem Layout Fix

This plan addresses the issue where the `PublicTrustSystem` UI element incorrectly repositions itself to (0,0) after a shake animation. We will fix this by targeting the internal `TrustBar` for the animation instead of the root node.

## Phase 1: Diagnosis & Test Setup [checkpoint: 8e0881f]
- [x] Task: Create a reproduction test case in `tests/unit/test_PublicTrustSystem.gd`.
- [x] Task: Verify that calling `_play_shake()` or `damage_trust()` causes the `PublicTrustSystem` node's `position` to change (failing test).
- [ ] Task: Conductor - User Manual Verification 'Phase 1: Diagnosis & Test Setup' (Protocol in workflow.md)

## Phase 2: Implementation (Refactor Shake Logic)
- [x] Task: Modify `src/components/PublicTrustSystem.gd` to store the original position of the `progress_bar`.
- [x] Task: Update `_play_shake()` to animate `progress_bar.position` instead of `self.position`.
- [x] Task: Ensure `_play_shake()` resets `progress_bar.position` to its original local position after the tween completes.
- [x] Task: Verify that tests now pass (position of root node remains unchanged during/after shake).
- [ ] Task: Conductor - User Manual Verification 'Phase 2: Implementation' (Protocol in workflow.md)

## Phase 3: Verification & Polish
- [ ] Task: Manually verify in `quiz_scene` that answering a question triggers a visual shake on the bar without moving the entire component.
- [ ] Task: Check for any layout "popping" or glitches when trust is updated.
- [ ] Task: Conductor - User Manual Verification 'Phase 3: Verification & Polish' (Protocol in workflow.md)
