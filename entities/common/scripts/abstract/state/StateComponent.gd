extends Node
class_name StateComponent

@export var state_label: RichTextLabel

var current_state: int = 0

signal state_changed(new_state: int, previous_state: int)

func set_state(new_state: int) -> void:
	if current_state == new_state:
		return

	var previous_state := current_state
	current_state = new_state

	state_changed.emit(new_state, previous_state)

	if is_instance_valid(state_label):
		state_label.text = "State: %s" % new_state


func is_state(state_to_check: int) -> bool:
	return current_state == state_to_check
