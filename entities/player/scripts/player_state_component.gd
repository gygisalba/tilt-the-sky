extends Node
class_name PlayerStateComponent

@export var state_label : RichTextLabel

enum PlayerState {
	IDLE,
	BUSY,
	MANTLING,
	SLIDING,
	DASHING,
}

var current_state := PlayerState.IDLE
signal player_state_changed(new_state: PlayerState, previous_state: PlayerState)

func set_player_state(new_state: PlayerState) -> void:
	var previous_state := new_state
	current_state = new_state
	player_state_changed.emit(new_state, previous_state)
	state_label.text = "State: %s" % new_state

func is_player_state(state_to_check: PlayerState) -> bool:
	return current_state == state_to_check
