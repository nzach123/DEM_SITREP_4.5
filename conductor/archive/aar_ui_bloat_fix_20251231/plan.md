# Implementation Plan - Fix UI Card Bloat in AAR Log

This track focuses on removing the `EvidenceImage` component from `LogEntryCard` to resolve layout bloat and achieve an ultra-compact data feed in the AAR screen.

## Phase 1: Test Initialization & Component Cleanup (TDD)
- [x] Task: Create failing test `tests/unit/test_log_entry_card_removal.gd` verifying `EvidenceImage` node exists and `evidence_image` property exists. a19fba0
- [x] Task: Remove `EvidenceImage` node from `src/scenes/LogEntryCard.tscn`. a19fba0
- [x] Task: Remove `evidence_image` variable and related logic from `src/scripts/LogEntryCard.gd`. a19fba0
- [x] Task: Update `tests/unit/test_log_entry_card_removal.gd` to assert `EvidenceImage` is NOT present and `evidence_image` is NOT in script. a19fba0
- [x] Task: Remove animation wrapper logic (`Slider`, `_setup_animation_wrapper`, `_sync_layout`) from `src/scripts/LogEntryCard.gd` and simplify `animate_entry`. 6ea5f55
- [ ] Task: Conductor - User Manual Verification 'Phase 1: Component Cleanup' (Protocol in workflow.md)

## Phase 2: Layout Optimization
- [x] Task: In `src/scenes/LogEntryCard.tscn`, ensure root node has `size_flags_vertical = 1` (SIZE_FILL) and NO expand flag. f8720c7
- [x] Task: In `src/scenes/AARScreen.tscn`, update `LogContainer` separation to `5` for tighter stacking. f8720c7
- [x] Task: Add test case to `tests/unit/test_log_entry_card_removal.gd` verifying vertical size flags. f8720c7
- [x] Task: Conductor - User Manual Verification 'Phase 2: Layout Optimization' (Protocol in workflow.md)

## Phase 3: Final Verification
- [x] Task: Run full test suite to ensure no regressions. 4b234a5
- [x] Task: Verify that long text still causes vertical expansion as per spec. 4b234a5
- [~] Task: Conductor - User Manual Verification 'Phase 3: Final Verification' (Protocol in workflow.md)
