# Specification: Fix ICS100 Course Loading and Improve Menu Robustness

## Overview
The `ICS100.json` file contains invalid JSON syntax (specifically `` markers) which causes parsing errors. Additionally, `MainMenu.gd` permissively loads invalid files.

## Functional Requirements

### 1. Data Sanitation
*   **Target File:** `assets/questions/ICS100.json`
*   **Action:** Remove all instances of invalid `` markers.
*   **Goal:** Ensure valid JSON structure.

### 2. Robust Course Scanning
*   **Target File:** `src/scripts/MainMenu.gd`
*   **Function:** `scan_courses()`
*   **Logic Change:**
    *   Retrieve course type via `GameManager`.
    *   **Strict Filter:** ONLY append if type == `"quiz"`.
    *   **Error Handling:** If type == `"unknown"`, print warning: `"Warning: Skipped invalid or corrupt course file: [file_name]"`.

## Acceptance Criteria
1.  **JSON Validation:** `ICS100.json` is valid JSON.
2.  **Course Loading:** "ICS100" loads successfully into `quiz_scene`.
3.  **Negative Testing:** Create a temporary file `test_corrupt.json` with garbage data. Verify it **DOES NOT** appear in the menu and **DOES** print a warning to the console.

## Out of Scope
*   Refactoring `GameManager`.
