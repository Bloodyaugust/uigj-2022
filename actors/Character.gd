extends KinematicBody2D

const WEAPON_ORBIT_RADIUS: float = 24.0

export var projectile_scene: PackedScene
export var scene_data: Resource

var aim_direction: Vector2 = Vector2.RIGHT
var data: CharacterData
var direction: Vector2 = Vector2.ZERO
var last_direction: Vector2 = Vector2.ZERO
var health: float

onready var _animated_sprite: AnimatedSprite = $"%AnimatedSprite"
onready var _weapon: Sprite = $"%Weapon"
onready var _attack_sfx: AudioStreamPlayer2D = $"%AttackSFX"
onready var _hurt_sfx: AudioStreamPlayer2D = $"%HurtSFX"

var _time_to_attack: float = 0.0

func attack() -> void:
  if _time_to_attack <= 0.0:
    _time_to_attack = data.attack_interval
    print("attacked")
    _attack_sfx.play()
    var _new_projectile: Node2D = projectile_scene.instance()

    _new_projectile.global_position = _weapon.global_position
    _new_projectile.global_rotation = _weapon.global_position.angle_to_point(global_position)
    _new_projectile.direction = global_position.direction_to(_weapon.global_position)

    _new_projectile.hits_group = "characters" if is_in_group("enemies") else "enemies"

    get_tree().get_root().add_child(_new_projectile)

func damage(amount: float) -> void:
  _hurt_sfx.play()
  health = clamp(health - amount, 0.0, data.health)
  if health <= 0.0:
    queue_free()

func _process(delta: float) -> void:
  _time_to_attack = clamp(_time_to_attack - delta, 0.0, data.attack_interval)

  _weapon.global_position = global_position + (aim_direction * WEAPON_ORBIT_RADIUS)
  _weapon.global_rotation = _weapon.global_position.angle_to_point(global_position) + PI / 2.0

func _physics_process(delta: float) -> void:
  if direction.length_squared() > 0:
    move_and_collide(direction * data.speed * delta)
#    _animated_sprite.play("walk")
    directional_walk()
    print(direction)
  else:
#    _animated_sprite.play("idle")
    directional_idle()

func _enter_tree() -> void:
  if !data && scene_data:
    data = scene_data
  health = data.health


func directional_walk():
  last_direction = direction
  if direction.x > 0:
    _animated_sprite.play("walk_right")
  elif direction.x < 0:
    _animated_sprite.play("walk_left")
  elif direction.y > 0:
    _animated_sprite.play("walk_down")
  elif direction.y < 0:
    _animated_sprite.play("walk_up")
  else:
    _animated_sprite.play("walk")

func directional_idle():
  if last_direction.x > 0:
    _animated_sprite.play("idle_right")
  elif last_direction.x < 0:
    _animated_sprite.play("idle_left")
  elif last_direction.y > 0:
    _animated_sprite.play("idle_down")
  elif last_direction.y < 0:
    _animated_sprite.play("idle_up")
  else:
    _animated_sprite.play("idle")
