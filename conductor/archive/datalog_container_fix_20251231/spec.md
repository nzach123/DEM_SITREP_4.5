# Specification: AARScreen Layout Fix

## 1. Overview
The `AARScreen` (After Action Report) layout is currently broken due to unconstrained content expansion within `LogEntryCard.tscn` instances. Long text strings and large images force the parent `PanelContainer` or `MarginContainer` to expand beyond the viewport width. This track will implement strict sizing constraints to ensure the layout remains responsive and contained.

## 2. Functional Requirements

### 2.1 LogEntryCard.tscn Updates
*   **Text Constraints:** Target `Label` nodes must have `autowrap_mode` set to `Word (Smart)` to prevent horizontal overflow.
*   **Image Constraints:** Target `TextureRect` nodes must have:
    *   `expand_mode` set to `Ignore Size` or `Fit Width`.
    *   `stretch_mode` set to `Keep Aspect Centered`.
*   **Container Flags:** The root node of `LogEntryCard` must have `size_flags_horizontal` set to `Fill` and `Expand`.

### 2.2 AARScreen.tscn Updates
*   **Parent Constraints:** Ensure the parent container in `AARScreen` (holding the cards) restricts width (e.g., using a `ScrollContainer` with horizontal scroll disabled, or fixed width anchors) to provide the necessary wrapping bounds for the children.

## 3. Testing Requirements
*   **Reproduction:** A new GUT test script (`tests/unit/test_aar_layout.gd`) will be created to instantiate `AARScreen` with specific oversized content (long text, 4k images).
*   **Assertion:** The test will verify that the `LogEntryCard` width does not exceed the `AARScreen` container width.

## 4. Acceptance Criteria
*   [ ] `LogEntryCard` width is strictly constrained within its parent container's bounds.
*   [ ] Label nodes in the card wrap text based on the parent's width (Autowrap enabled).
*   [ ] TextureRect nodes maintain aspect ratio without forcing the container to expand beyond limits.
*   [ ] The layout constraints persist across different screen resolutions or container sizes.
