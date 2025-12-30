# Specification: Restore Dynamic Casualty Logic

## 1. Overview
**Track Type:** Feature (Restoration)
**Goal:** Restore the dynamic casualty calculation logic where the casualty count for incorrect answers is determined by a base rate combined with a random variance, rather than a hard-coded static value. This variance should scale with difficulty.

## 2. Requirements
*   **Update `DIFFICULTY_CONFIG`:** Modify the configuration in `src/autoload/GameManager.gd` to support a range instead of a single `casualty_penalty` value.
    *   **Structure:** Replace `casualty_penalty` with `casualty_min` and `casualty_max`.
    *   **Low Difficulty:** Min: 0, Max: 0 (No penalty).
    *   **Medium Difficulty:** Min: 100, Max: 300.
    *   **High Difficulty:** Min: 400, Max: 800.
*   **Update Calculation Logic:** Modify `src/scripts/GameSession.gd` (specifically `_handle_wrong`) to calculate the penalty using `randi_range(min, max)` based on the current difficulty settings.
*   **UI Feedback:** Ensure the "SIGNAL LOST: X CASUALTIES" message correctly reflects the calculated random amount for that specific instance.

## 3. Verification Plan
*   **Automated Testing:**
    *   Create a new test file `tests/unit/test_dynamic_casualties.gd`.
    *   Test Low difficulty (assert always 0).
    *   Test Medium/High difficulty (assert result is within [min, max] range).
    *   Test multiple failures to ensure randomness (results vary).
*   **Manual Verification:**
    *   Play a session on Medium/High.
    *   Fail questions intentionally.
    *   Verify the feedback text matches the score deduction.

## 4. Constraints
*   Ensure the `casualty_min` and `casualty_max` are integers.
*   Maintain existing system architecture (GameManager config -> GameSession logic).
