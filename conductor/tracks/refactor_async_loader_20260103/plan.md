# Implementation Plan: Async Question Loader

## Phase 1: QuestionLoader Class
- [ ] Task: Create `src/systems/QuestionLoader.gd`.
- [ ] Task: Move parsing logic from `GameManager` to `QuestionLoader`.
- [ ] Task: Implement `load_questions_async()` using `Thread` or `ResourceLoader` style chunking.
    - *Note*: Since we scan JSONs, `Thread` is best.

## Phase 2: Integration
- [ ] Task: Instantiate `QuestionLoader` in `GameManager`.
- [ ] Task: Trigger loading on game start (Splash Screen) and handle completion signal.
- [ ] Task: Unit Test `QuestionLoader` with mocked file access (if possible) or integration test.
- [ ] Task: Conductor - User Manual Verification 'Async Loader' (Protocol in workflow.md)
