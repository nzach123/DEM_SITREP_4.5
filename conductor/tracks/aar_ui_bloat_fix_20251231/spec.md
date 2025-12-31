# Track Specification: Fix UI Card Bloat in AAR Log

## 1. Overview
**Goal:** Resolve the layout issue where `LogEntryCard` instances expand excessively in the After Action Report (AAR) screen.
**Root Cause:** The `TextureRect` (Icon) was forcing the container to match raw image resolutions.
**Solution:** Instead of reconfiguring the icon, we will remove the `TextureRect` component and its associated logic entirely. This aligns with the "Ultra-Compact" design goal.

## 2. Functional Requirements
### 2.1 Component Modification (`LogEntryCard.tscn`)
- **Remove:** Delete the `TextureRect` (Icon) node.
- **Root Container:** Ensure the root node (PanelContainer/MarginContainer) has `size_flags_vertical` set to `SIZE_FILL` (not expand) to allow tight stacking.
- **Layout:** The card must still support variable height based on the text content (Grow Vertically).

### 2.2 Script Cleanup (`LogEntryCard.gd`)
- **Remove:** Delete any `@onready` variables referencing the icon.
- **Remove:** Delete any logic in `_ready()` or `setup()` that assigns textures or manipulates the icon's properties.

### 2.3 Parent Container (`AARScreen.tscn`)
- **Spacing:** Ensure the `VBoxContainer` housing the cards has a defined separation (e.g., `theme_override_constants/separation = 10` or lower for ultra-compactness) to verify the "bloat" is gone.

## 3. Acceptance Criteria
- [ ] `LogEntryCard` no longer contains an icon.
- [ ] Cards in the AAR screen stack tightly with minimal vertical gaps.
- [ ] Long text entries cause the card to expand vertically to fit the text, without breaking the layout of surrounding cards.
- [ ] No script errors regarding missing nodes or null references.
