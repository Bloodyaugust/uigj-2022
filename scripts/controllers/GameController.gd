extends Node2D

const ROOM_SCENES: Array = [
  preload("res://actors/rooms/Easy.tscn"),
  preload("res://actors/rooms/Room1.tscn"),
 ]

onready var _enemy_container: Node = get_tree().get_root().find_node("EnemyContainer", true, false)
onready var _player_container: Node = get_tree().get_root().find_node("PlayerContainer", true, false)
onready var _room_container: Node = get_tree().get_root().find_node("RoomContainer", true, false)
onready var _transition: ColorRect = get_tree().get_root().find_node("Transition", true, false)

func begin_transition() -> void:
  _transition.begin_transition()

func start_game() -> void:
  Store.set_state("transition_to", "room")
  begin_transition()
  Store.set_state("game", GameConstants.GAME_IN_PROGRESS)

func _on_store_state_changed(state_key: String, substate) -> void:
  match state_key:
    "game":
      match substate:
        GameConstants.GAME_STARTING:
          call_deferred("start_game")

func _on_transition_midway() -> void:
  GDUtil.queue_free_children(_enemy_container)
  GDUtil.queue_free_children(_player_container)

  if Store.state.transition_to == "room":
    var _new_room: TileMap = ROOM_SCENES[randi() % ROOM_SCENES.size()].instance()

    _new_room.global_position = Vector2.ZERO
    _room_container.add_child(_new_room)

  if Store.state.transition_to == "menu":
    Store.set_state("game", GameConstants.GAME_OVER)
    Store.set_state("client_view", ClientConstants.CLIENT_VIEW_MAIN_MENU)

func _ready() -> void:
  Store.connect("state_changed", self, "_on_store_state_changed")
  Store.connect("transition_midway", self, "_on_transition_midway")
