extends Node2D

const RESCUE_CHARACTERS: Array = [
  preload("res://actors/characters/Archer.tscn"),
  preload("res://actors/characters/Mage.tscn"),
 ]
const RESCUE_INTERVAL: int = 3
const ROOM_SCENES: Array = [
  preload("res://actors/rooms/Room1.tscn"),
  preload("res://actors/rooms/Room2.tscn"),
  preload("res://actors/rooms/Room3.tscn"),
  preload("res://actors/rooms/Room4.tscn"),
  preload("res://actors/rooms/Room5.tscn"),
  preload("res://actors/rooms/Room6.tscn"),
  preload("res://actors/rooms/Room7.tscn"),
  preload("res://actors/rooms/Room8.tscn"),
  preload("res://actors/rooms/Room9.tscn"),
  preload("res://actors/rooms/Room10.tscn")
 ]

var party_members: Array = [
  preload("res://actors/characters/Fighter.tscn"),
 ]

onready var _enemy_container: Node = get_tree().get_root().find_node("EnemyContainer", true, false)
onready var _player_container: Node = get_tree().get_root().find_node("PlayerContainer", true, false)
onready var _room_container: Node = get_tree().get_root().find_node("RoomContainer", true, false)
onready var _transition: ColorRect = get_tree().get_root().find_node("Transition", true, false)

var _rooms_cleared: int = -1
var _members_rescued: int = 0

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
    _rooms_cleared += 1

    if _rooms_cleared >= ROOM_SCENES.size():
      Store.set_state("transition_to", "menu")
    else:
      if _rooms_cleared % RESCUE_INTERVAL == 0 && _rooms_cleared != 0 && _members_rescued < RESCUE_CHARACTERS.size():
        party_members.append(RESCUE_CHARACTERS[_members_rescued])
        _members_rescued += 1

      var _new_room: TileMap = ROOM_SCENES[_rooms_cleared].instance()

      _new_room.global_position = Vector2.ZERO
      _room_container.add_child(_new_room)

  if Store.state.transition_to == "menu":
    _rooms_cleared = -1
    _members_rescued = 0
    party_members = [load("res://actors/characters/Fighter.tscn")]
    Store.set_state("game", GameConstants.GAME_OVER)
    Store.set_state("client_view", ClientConstants.CLIENT_VIEW_MAIN_MENU)

func _ready() -> void:
  Store.connect("state_changed", self, "_on_store_state_changed")
  Store.connect("transition_midway", self, "_on_transition_midway")
