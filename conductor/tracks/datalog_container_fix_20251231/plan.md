# Plan: AARScreen Layout Fix

## Phase 1: Setup and Reproduction (TDD Red) [checkpoint: 20ee2fa]
- [x] Task: Create reproduction GUT test `tests/unit/test_aar_layout.gd` that instantiates `LogEntryCard` with oversized content. 40247b0
- [x] Task: Execute tests to confirm failure (width overflow). 40247b0
- [x] Task: Conductor - User Manual Verification 'Phase 1: Setup and Reproduction' (Protocol in workflow.md) 20ee2fa

## Phase 2: Implement Component Fixes (TDD Green) [checkpoint: 13f4cca]
- [x] Task: Update `LogEntryCard.tscn` root node size flags to Fill and Expand. 0de1a1f
- [x] Task: Update `Label` nodes in `LogEntryCard.tscn` to use Autowrap: Word (Smart). 0de1a1f
- [x] Task: Update `TextureRect` nodes in `LogEntryCard.tscn` to use Expand Mode: Fit Width and Stretch Mode: Keep Aspect Centered. 0de1a1f
- [x] Task: Run reproduction test to verify partial or full resolution. 0de1a1f
- [x] Task: Conductor - User Manual Verification 'Phase 2: Implement Component Fixes' (Protocol in workflow.md) 13f4cca

## Phase 3: Implement Parent Constraints and Final Polish [checkpoint: b2624f5]
- [x] Task: Review and update `AARScreen.tscn` parent containers to ensure they provide rigid width bounds (e.g., via `ScrollContainer` configuration). 0de1a1f
- [x] Task: Run all unit tests to ensure no regressions in layout or card functionality. b2624f5
- [x] Task: Conductor - User Manual Verification 'Phase 3: Implement Parent Constraints and Final Polish' (Protocol in workflow.md) b2624f5

## Phase 4: Runtime Debugging and Layout Overhaul [checkpoint: 9e971ca]
- [x] Task: Investigate why `ScrollContainer` constraint might be failing in runtime (e.g. check `VBoxContainer` flags). 9e971ca
- [x] Task: Apply `custom_minimum_size.x = 1` to `LogEntryCard` root or `Slider` to ensure it allows shrinking. (Implemented dynamic label sizing). 9e971ca
- [x] Task: Conductor - User Manual Verification 'Phase 4: Runtime Debugging and Layout Overhaul' (Protocol in workflow.md) 9e971ca
- [ ] Task: Conductor - User Manual Verification 'Phase 3: Implement Parent Constraints and Final Polish' (Protocol in workflow.md)
