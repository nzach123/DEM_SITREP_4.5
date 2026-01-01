extends GutTest

var PublicTrustSystem = load("res://src/components/PublicTrustSystem.gd")
var trust_system
var container

func before_each():
	container = VBoxContainer.new()
	container.set_size(Vector2(200, 200))
	add_child_autofree(container)
	
	trust_system = PublicTrustSystem.new()
	# Create internal structure that script expects
	var bar = TextureProgressBar.new()
	bar.name = "TrustBar"
	trust_system.add_child(bar)
	
	var label = Label.new()
	label.name = "Label"
	bar.add_child(label)
	
	var anim = AnimationPlayer.new()
	anim.name = "AnimationPlayer"
	trust_system.add_child(anim)
	
	container.add_child(trust_system)
	
	# Wait for ready
	await wait_frames(1)

func test_initial_setup():
	assert_not_null(trust_system.progress_bar)
	assert_eq(trust_system.current_trust, 100.0)

func test_damage_trust_triggers_shake_and_modifies_position():
	# Position before shake should be determined by layout (e.g. 0,0 relative to parent if it's the first child)
	# But let's verify that the shake *changes* the position property
	
	# Manually set a non-zero position to simulate layout having placed it somewhere
	# (Though VBoxContainer forces it, we can check if it gets tweened)
	
	trust_system.damage_trust(10.0)
	
	# We can't easily check 'during' the tween in a unit test without complex waiting, 
	# but we can check if the code *attempts* to animate 'position' of 'self'.
	# Since _play_shake uses create_tween(), we can't inspect the tween easily.
	
	# However, the bug is that it resets to Vector2.ZERO at the end.
	# If we set the position to something else *before* damage, and it snaps to zero, that's the bug?
	# Wait, in a VBoxContainer, the position IS managed. 
	# The bug is that the tween overrides the VBoxContainer's placement.
	
	# Let's see if we can spy on the position property or just verify the logic.
	# Actually, the most reliable way to fail this test given the bug description:
	# "PublicTrustSystem UI element unexpectedly repositions itself to the top-left"
	# The code explicitly tweens `self.position` to `original_pos` which is hardcoded to `Vector2.ZERO`.
	
	# So if we place the container such that the child is NOT at 0,0 (e.g. add a spacer before it),
	# and then trigger shake, it should snap to 0,0.
	
	var spacer = Control.new()
	spacer.custom_minimum_size = Vector2(0, 50)
	container.move_child(trust_system, 1) # Ensure trust system is second
	container.add_child(spacer)
	container.move_child(spacer, 0) # Spacer first
	
	# Force layout update
	container.queue_sort()
	await wait_frames(2)
	
	var initial_pos = trust_system.position
	# With a 50px spacer, y should be >= 50
	assert_gt(initial_pos.y, 40.0, "Trust system should be offset by spacer")
	
	# Trigger damage and shake
	trust_system.damage_trust(10.0)
	
	# Wait for tween to finish (0.05 * 5 + 0.05 = ~0.3s)
	await wait_seconds(0.5)
	
	var final_pos = trust_system.position
	
	# The BUG: It snaps to Vector2.ZERO (or close to it) because `original_pos` was hardcoded to ZERO.
	# The FIX: It should return to `initial_pos` (or not move `self` at all).
	
	# So, for the FAIL test, we assert that the position IS corrupted (moved to 0,0) OR we write the "correct" assertion and watch it fail.
	# TDD says write the test that *defines expected behavior* and watch it fail.
	# Expected behavior: It stays at `initial_pos`.
	
	assert_eq(final_pos, initial_pos, "Trust system should return to its layout position, not (0,0)")

