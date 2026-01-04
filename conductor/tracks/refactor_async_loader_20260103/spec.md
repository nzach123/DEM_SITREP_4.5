# Specification: Async Question Loader

## 1. Overview
This track addresses the frame drop during startup caused by synchronous file I/O when loading questions. We will move this logic to a background thread encapsulated in a `QuestionLoader` class.

## 2. Functional Requirements
- **Non-Blocking:** Loading thousands of JSON questions must not freeze the main thread.
- **Completion Signal:** `QuestionLoader` must emit `loading_complete(questions)` when done.
- **Thread Safety:** Ensure shared data is accessed safely (though populating a local array and passing it back on completion is safest).

## 3. Acceptance Criteria
- [ ] Game startup animation (Splash Screen) does not stutter.
- [ ] All questions are loaded correctly (count matches expected).
- [ ] Unittests verify `load_async` returns correct data structure.
