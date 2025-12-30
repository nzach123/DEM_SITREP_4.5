# Specification: Refactor - Codebase Cleanup (AI-Slop Removal)

## 1. Overview
**Track Type:** Refactor
**Goal:** Clean up the codebase by removing "AI-slop," specifically focusing on unnecessary, verbose, or redundant comments and dead code. This aims to improve code readability and maintainability without altering runtime behavior.

## 2. Scope
*   **Target Areas:** All `.gd` scripts in `src/` and `tests/`.
*   **Primary Action:**
    *   Remove comments that explain *what* the code is doing (e.g., `# This sets the variable to 5`).
    *   Remove commented-out code (dead code).
    *   Remove conversational or "bot-like" comments (e.g., `# Here is the function you asked for`).
    *   Keep comments that explain *why* complex logic exists.
*   **Out of Scope:**
    *   Renaming variables or functions (unless they are clearly generated/obfuscated).
    *   Changing logic flow (unless it's strictly dead code removal).

## 3. Verification Plan
*   **Automated Testing:** Execute the full GUT test suite (`tests/unit`) before and after changes to ensure no functional regressions.
    *   Command: `C:\00_Godot\z_installer\Godot_v4.5.1-stable_win64_console.exe --headless -s addons/gut/gut_cmdln.gd -gdir=tests/unit -gexit`
*   **Success Criteria:**
    *   All existing tests pass.
    *   Codebase size is reduced (in terms of lines of text) while functionality remains identical.

## 4. Constraints
*   Do not modify logic.
*   Preserve docstrings/comments that are required for documentation generation (if any) or that explain critical architectural decisions.
