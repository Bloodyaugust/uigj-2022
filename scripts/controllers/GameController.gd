extends Node2D

func _on_store_state_changed(state_key: String, substate) -> void:
  match state_key:
    "game":
      pass

func _ready() -> void:
  Store.connect("state_changed", self, "_on_store_state_changed")
