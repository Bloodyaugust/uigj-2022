extends StaticBody2D

export var is_closed = true

onready var _collider: CollisionShape2D = $"%CollisionShape2D"
onready var _animated_sprite: AnimatedSprite = $"%AnimatedSprite"
onready var _open_sfx: AudioStreamPlayer2D = $"%OpenSFX"

# Called when the node enters the scene tree for the first time.
func _ready():
  if is_closed:
    _collider.disabled = false
    _animated_sprite.play("idle_closed")
  else:
    _collider.disabled = true
    _animated_sprite.play("idle_opened")
  pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#  pass

func toggle_open():
  if is_closed:
    open()
  else:
    close()

func open():
  is_closed = false
  _collider.disabled = true
  _open_sfx.play()
  _animated_sprite.play("open")

func close():
  is_closed = true
  _collider.disabled = false
  _open_sfx.play()
  _animated_sprite.play("close")
