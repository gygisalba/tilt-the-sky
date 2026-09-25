extends Node
class_name SlideComponent

@export var player : Player
@export var state : PlayerStateComponent

@export var minimum_steepness := 0.85
@export var slide_speed := 12.0
@export var jump_boost := 8.0

var slide_direction := Vector3.ZERO 

func handle_slide() -> void:
	var floor_normal = player.get_floor_normal()
	
	if floor_normal.y < minimum_steepness:
		state.set_player_state(state.PlayerState.SLIDING)
		slide_direction = floor_normal.slide(Vector3.UP).normalized()
		player.velocity = slide_direction * slide_speed
	else:
		state.set_player_state(state.PlayerState.IDLE)
