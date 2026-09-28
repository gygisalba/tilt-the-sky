extends StateComponent
class_name AttackerStateComponent

enum AttackerState {
	SHEATHED,
	UNSHEATHED,
}

func _ready() -> void:
	current_state = AttackerState.SHEATHED
