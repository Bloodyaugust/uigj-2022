extends Node2D

const MELEE_ATTACK_RANGE: float = 40.0
const RANGED_ATTACK_RANGE: float = 150.0

onready var character: KinematicBody2D = get_parent()

var character_data: CharacterData

var _target: Node2D

func _find_target() -> void:
  var _enemies: Array = get_tree().get_nodes_in_group("enemies")

  if _enemies.size() > 0:
    _target = _enemies[0]

func _process(delta):
  var _movement_direction: Vector2 = Vector2.ZERO

  if !GDUtil.reference_safe(_target):
    _find_target()

  if !GDUtil.reference_safe(_target):
    return

  match character_data.attack_type:
    "melee":
      if global_position.distance_to(_target.global_position) > MELEE_ATTACK_RANGE:
        _movement_direction = global_position.direction_to(_target.global_position)
    "ranged":
      if global_position.distance_to(_target.global_position) <= RANGED_ATTACK_RANGE:
        _movement_direction = -global_position.direction_to(_target.global_position)

  character.direction = _movement_direction
  character.aim_direction = global_position.direction_to(_target.global_position)

  match character_data.attack_type:
    "melee":
      if global_position.distance_to(_target.global_position) <= MELEE_ATTACK_RANGE:
        character.attack()
    "ranged":
      character.attack()

func _ready() -> void:
  character_data = character.data
