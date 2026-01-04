# Specification: CRT Layering Refactor

## 1. Overview
This track fixes the brittle reliance on `move_child` references by moving the CRT post-processing effect into the `GameOverlay` (PostProcess layer). This ensures the CRT effect consistently applies to the entire screen, including UI, without manual index manipulation.

## 2. Functional Requirements
- **Post-Process Layer:** The CRT shader must exist in a `CanvasLayer` (within GameOverlay) that is higher than the Game World but potentially lower than "Critical" UI if desired (though usually CRT goes over everything).
- **Removal of Hacks:** Any code searching for "CRTScreen" nodes to re-order children must be deleted.

## 3. Acceptance Criteria
- [ ] CRT effect is visible on Main Menu, Gameplay, and Pause Menu.
- [ ] `find_child("CRTScreen")` usage is removed from `GameManager`.
- [ ] No visual regressions in the CRT effect appearance.
