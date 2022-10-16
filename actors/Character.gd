extends KinematicBody2D

const WEAPON_ORBIT_RADIUS: float = 12.0

export var scene_data: Resource

var aim_direction: Vector2 = Vector2.ZERO
var data: CharacterData
var direction: Vector2 = Vector2.ZERO
var health: float

onready var _animated_sprite: AnimatedSprite = $"%AnimatedSprite"
onready var _weapon: Sprite = $"%Weapon"

var _time_to_attack: float = 0.0
func attack() -> void:
  if _time_to_attack <= 0.0:
    _time_to_attack = data.attack_interval
    print("attacked")
    match data.attack_type:
      "melee":
        # TODO: Once projectiles are created, instantiate that projectile with type and damage just outside player collider in direction
        pass
func damage(amount: float) -> void:
  health = clamp(health - amount, 0.0, data.health)
  if health <= 0.0:
    queue_free()
func _process(delta: float) -> void:
  _time_to_attack = clamp(_time_to_attack - delta, 0.0, data.attack_interval)

  _weapon.global_position = global_position + (aim_direction * WEAPON_ORBIT_RADIUS)
  _weapon.global_rotation = _weapon.global_position.angle_to_point(global_position)

func _physics_process(delta: float) -> void:
  if direction.length_squared() > 0:
    move_and_collide(direction * data.speed * delta)
    _animated_sprite.play("walk")
  else:
    _animated_sprite.play("idle")
func _enter_tree() -> void:
  if !data && scene_data:
    data = scene_data
  health = data.health
