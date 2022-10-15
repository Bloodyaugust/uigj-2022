extends Node2D

onready var character: KinematicBody2D = get_parent()

func _process(delta):
  var _movement_direction: Vector2 = Vector2.ZERO

  _movement_direction += Vector2(Input.get_axis("move_left", "move_right"), Input.get_axis("move_up", "move_down")).normalized()

  character.direction = _movement_direction

  if Input.is_action_just_pressed("attack"):
    character.attack()
