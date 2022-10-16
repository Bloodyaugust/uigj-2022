extends Node2D

export var scene_data: Resource

var data: ProjectileData
var direction: Vector2 = Vector2.ZERO
var hits_group: String

onready var _area2d: Area2D = $"%Area2D"
onready var _sprite: Sprite = $"%Sprite"

var _time_to_die: float

func _enter_tree() -> void:
  data = scene_data

func _on_body_entered(body: Node) -> void:
  if body.is_in_group(hits_group) && body.has_method("damage"):
    body.damage(data.damage)

func _physics_process(delta: float) -> void:
  if data.moves:
    global_position += direction * data.speed * delta

func _process(delta: float) -> void:
  _time_to_die -= delta

  if _time_to_die <= 0:
    queue_free()

func _ready() -> void:
  _area2d.connect("body_entered", self, "_on_body_entered")
  
  _sprite.texture = data.sprite
  _time_to_die = data.lifetime
