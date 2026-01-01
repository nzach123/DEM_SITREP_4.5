# Specification: Fix AAR Screen Music Playback

## 1. Overview
The AAR (After Action Report) screen is intended to play distinct musical cues based on the player's performance ("Victory" for rank >= B, "Fail" for lower). Currently, these sounds are failing to play (silence) despite the logic appearing correct in `AARScreen.gd` and `AARAudioManager.gd`. This track focuses on diagnosing the root cause—likely node assignment, resource loading, or audio bus configuration—and implementing a robust fix.

## 2. Problem Statement
*   **Symptoms:** When the AAR screen loads, neither the Victory nor Fail music plays. The result is silence.
*   **Target Components:** `AARScreen.gd`, `AARAudio.gd`, and the `AARScreen.tscn` scene structure.
*   **Current State:** `AARScreen` calls `audio_manager.play_fail_music()` or `play_victory_music()`. `AARAudioManager` attempts to play `music_victory` or `music_fail` AudioStreamPlayers.

## 3. Scope of Work
*   **Diagnosis:**
    *   Verify `audio_manager` is correctly assigned in `AARScreen`.
    *   Verify `music_victory` and `music_fail` AudioStreamPlayers are correctly assigned in `AARAudioManager` (checking both Inspector exports and `_ready` fallback logic).
    *   Verify valid `AudioStream` resources (Ogg/Wav) are assigned to these players.
    *   Check Audio Bus layout (default "Master" or specific buses) to ensuring routing is not muted.
*   **Fix:**
    *   Correct any broken node references or missing resources in the scene/script.
    *   Ensure `AARAudioManager` correctly handles the playback request.
    *   (Optional) If nodes are missing, re-instantiate them with correct streams.
*   **Verification:**
    *   Run `AARScreen` (or complete a level) and confirm audible playback of the correct track based on score.

## 4. Technical Constraints
*   **Engine:** Godot 4.5.
*   **Language:** GDScript.
*   **Architecture:** Use existing `AARAudioManager` pattern; do not introduce a new global singleton unless the local approach is proven unviable.
*   **Platform:** Windows (Dev), HTML5 (Target) - ensure audio formats are compatible (unlikely the issue here, but good to note).

## 5. Success Criteria
*   **Victory Music:** Plays when Rank is S, A, or B.
*   **Fail Music:** Plays when Rank is F.
*   **No Errors:** Debugger shows no "null instance" errors regarding audio playback.
