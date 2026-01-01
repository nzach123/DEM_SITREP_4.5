# Specification: PublicTrustSystem Layout Fix

## Overview
**Goal:** Fix a bug where the `PublicTrustSystem` UI element jumps to the top-left corner of its parent container after a "shake" animation is triggered (typically after a user submits an answer).

## Root Cause Analysis
The `PublicTrustSystem.gd` script contains a `_play_shake()` function that directly manipulates the node's `position` property. Since `PublicTrustSystem` is a child of a `VBoxContainer`, the container manages its position. When the shake tween resets `position` to `Vector2.ZERO`, it overrides the container's layout logic, causing the node to snap to the top-left.

## Functional Requirements
1. **Preserve Layout Integrity:** The `PublicTrustSystem` root node must remain layout-locked within its parent `VBoxContainer`.
2. **Restore Visual Feedback:** The shake animation must still occur to provide micro-feedback on trust changes.
3. **Internal Shaking:** The shake effect should be applied to internal UI components (e.g., the `TrustBar`) rather than the root node.

## Implementation Plan (Option B)
- Modify `PublicTrustSystem.gd` to target `progress_bar.position` for the shake effect.
- Ensure the `progress_bar` (TrustBar) has its own local coordinate space that doesn't affect the parent's layout.
- Update `_play_shake()` to capture and return to the internal node's original local position.

## Acceptance Criteria
- [ ] In `quiz_scene`, answering a question triggers the shake effect without moving the entire `PublicTrustSystem` node to (0,0).
- [ ] The `PublicTrustSystem` remains centered/positioned correctly within the left-hand sidebar according to its `size_flags`.
- [ ] The visual "shake" is clearly visible on the progress bar.

## Out of Scope
- Changing the visual design of the trust system.
- Implementing a shader-based shake (unless requested later).
