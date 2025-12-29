# Product Guidelines

## Visual Identity: Sleek Tactical
- **Typography:**
    - **Main Titles:** Bebas Neue (Bold, authoritative).
    - **Sub-headers & Body:** Rajdhani or Montserrat (Clean, readable, tactical feel).
- **Aesthetic:** High-contrast, sleek interface inspired by emergency management dashboards. Use clean lines and a focused color palette.
- **Layout:** Minimalist Overlays. Both Settings and Credits should appear as centered, high-focus panels over the existing menu/game background to maintain context while minimizing clutter.

## User Experience (UX) & Micro-feedback
- **Auditory Snap:** Every button hover and click must provide a crisp, short SFX response to reinforce the arcade feel.
- **Visual Pulsing:** Active interactive elements (sliders, buttons) should exhibit subtle scaling or brightness shifts to indicate focus and interactivity.
- **Seamless Transitions:** Utilize the project's existing `SceneTransition` system for smooth fades when entering or exiting these overlays.

## Implementation Standards
- **Godot Native:** Heavily leverage `Control` nodes, `Theme` resources, and built-in signals.
- **Responsive Design:** Ensure the overlays are centered and scale correctly for different resolutions, prioritizing HTML5/Web compatibility.
