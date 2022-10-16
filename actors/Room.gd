extends TileMap

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

onready var _enemy_container: Node = get_tree().get_root().find_node("EnemyContainer", true, false)
onready var _enemy_spawns: Node2D = $"%EnemySpawns"
onready var _exit_room: Area2D = $"%ExitRoom"
onready var _player_container: Node = get_tree().get_root().find_node("PlayerContainer", true, false)
onready var _player_spawn: Node2D = $"%PlayerSpawn"

var room_data: RoomData

func _enter_tree() -> void:
  room_data = scene_data

func _on_exit_room_body_enetered(body: Node) -> void:
  # TODO: Get the next room, transition, do the stuff
  print("room exited")

func _ready() -> void:
  var _enemy_spawn_points: Array = _enemy_spawns.get_children()

  _exit_room.connect("body_entered", self, "_on_exit_room_body_enetered")

  for _i in range(room_data.difficulty):
    var _new_enemy: Node2D = ENEMY_SCENES[randi() % ENEMY_SCENES.size()].instance()

    _new_enemy.global_position = _enemy_spawn_points[_i].global_position

    _enemy_container.add_child(_new_enemy)

  var _player_character: Node2D = CHARACTER_SCENES[0].instance()
  var _player_controller: Node = PLAYER_SCRIPT.new()

  _player_character.add_child(_player_controller)
  _player_container.add_child(_player_character)
