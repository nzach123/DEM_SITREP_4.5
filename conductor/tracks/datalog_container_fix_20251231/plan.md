# Plan: AARScreen Layout Fix

## Phase 1: Setup and Reproduction (TDD Red) [checkpoint: 20ee2fa]
- [x] Task: Create reproduction GUT test `tests/unit/test_aar_layout.gd` that instantiates `LogEntryCard` with oversized content. 40247b0
- [x] Task: Execute tests to confirm failure (width overflow). 40247b0
- [x] Task: Conductor - User Manual Verification 'Phase 1: Setup and Reproduction' (Protocol in workflow.md) 20ee2fa

## Phase 2: Implement Component Fixes (TDD Green)
- [~] Task: Update `LogEntryCard.tscn` root node size flags to Fill and Expand.
- [ ] Task: Update `Label` nodes in `LogEntryCard.tscn` to use Autowrap: Word (Smart).
- [ ] Task: Update `TextureRect` nodes in `LogEntryCard.tscn` to use Expand Mode: Fit Width and Stretch Mode: Keep Aspect Centered.
- [ ] Task: Run reproduction test to verify partial or full resolution.
- [ ] Task: Conductor - User Manual Verification 'Phase 2: Implement Component Fixes' (Protocol in workflow.md)

## Phase 3: Implement Parent Constraints and Final Polish
- [ ] Task: Review and update `AARScreen.tscn` parent containers to ensure they provide rigid width bounds (e.g., via `ScrollContainer` configuration).
- [ ] Task: Run all unit tests to ensure no regressions in layout or card functionality.
- [ ] Task: Conductor - User Manual Verification 'Phase 3: Implement Parent Constraints and Final Polish' (Protocol in workflow.md)
