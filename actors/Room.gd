extends TileMap

const AI_CHARACTER_SCRIPT: Script = preload("res://scripts/controllers/AICharacterController.gd")
const CHARACTER_SPAWN_RADIUS: float = 15.0
const CHARACTER_SCENES: Array = [
  preload("res://actors/characters/Fighter.tscn"),
  preload("res://actors/characters/Mage.tscn"),
 ]
const ENEMY_SCENES: Array = [
  preload("res://actors/enemies/Basic.tscn"),
  preload("res://actors/enemies/EnemyWitch.tscn"),
 ]
const PLAYER_SCRIPT: Script = preload("res://scripts/controllers/PlayerController.gd")

export var scene_data: Resource

onready var _door: Node2D = find_node("HorizontalDoor")
onready var _enemy_container: Node = get_tree().get_root().find_node("EnemyContainer", true, false)
onready var _enemy_spawns: Node2D = $"%EnemySpawns"
onready var _exit_room: Area2D = $"%ExitRoom"
onready var _player_container: Node = get_tree().get_root().find_node("PlayerContainer", true, false)
onready var _player_spawn: Node2D = $"%PlayerSpawn"

var room_data: RoomData

var _cleared: bool = false
var _enemies: Array = []
var _characters: Array = []

func _enter_tree() -> void:
  room_data = scene_data

func _on_exit_room_body_enetered(body: Node) -> void:
  GameController.begin_transition()

func _on_transition_midway() -> void:
  queue_free()

func _process(delta: float) -> void:
  if !_cleared:
    var _dead_enemies: int = 0
    var _dead_characters: int = 0

    for _enemy in _enemies:
      if !GDUtil.reference_safe(_enemy):
        _dead_enemies += 1

    for _character in _characters:
      if !GDUtil.reference_safe(_character):
        _dead_characters += 1

    if _dead_enemies == _enemies.size():
      _cleared = true
      _door.open()
    elif _dead_characters == _characters.size():
      _cleared = true
      Store.set_state("transition_to", "menu")
      GameController.begin_transition()

func _ready() -> void:
  var _enemy_spawn_points: Array = _enemy_spawns.get_children()

  Store.connect("transition_midway", self, "_on_transition_midway")
  _exit_room.connect("body_entered", self, "_on_exit_room_body_enetered")

  for _i in range(room_data.difficulty):
    var _new_enemy: Node2D = ENEMY_SCENES[randi() % ENEMY_SCENES.size()].instance()

    _new_enemy.global_position = _enemy_spawn_points[_i].global_position

    _enemy_container.add_child(_new_enemy)
    _enemies.append(_new_enemy)

  var _player_controller_added: bool = false
  for _character_scene in GameController.party_members:
    var _player_character: Node2D = _character_scene.instance()

    if !_player_controller_added:
      var _player_controller: Node = PLAYER_SCRIPT.new()
      _player_character.add_child(_player_controller)
      _player_controller_added = true
    else:
      var _ai_controller: Node = AI_CHARACTER_SCRIPT.new()
      _player_character.add_child(_ai_controller)

    _player_character.global_position = _player_spawn.global_position + Vector2(rand_range(-CHARACTER_SPAWN_RADIUS, CHARACTER_SPAWN_RADIUS), rand_range(-CHARACTER_SPAWN_RADIUS, CHARACTER_SPAWN_RADIUS))
    _player_container.add_child(_player_character)
    _characters.append(_player_character)
