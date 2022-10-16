extends ColorRect

onready var _animation_player: AnimationPlayer = $"%TransitionAnimationPlayer"

func begin_transition() -> void:
  _animation_player.play("transition")

func transition_completed() -> void:
  Store.emit_signal("transition_completed")

func transition_midway() -> void:
  Store.emit_signal("transition_midway")
