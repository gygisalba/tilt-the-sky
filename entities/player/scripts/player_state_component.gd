extends StateComponent
class_name PlayerStateComponent

enum PlayerState {
	IDLE,
	BUSY,
	SLIDING,
}

func _ready() -> void:
	current_state = PlayerState.IDLE
