extends Node
class_name AttackerComponent

@onready var camera_component: CameraComponent = %CameraComponent
@onready var attack_collider: CollisionShape3D = %AttackCollider
@onready var attack_active_timer: Timer = %AttackActiveTimer
@onready var attacker_state: AttackerStateComponent = %AttackerStateComponent

func _ready() -> void:
	attack_collider.disabled = true
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("swing_blade"):
		attacker_state.set_state(attacker_state.AttackerState.UNSHEATHED)
		attack_collider.disabled = false
		attack_active_timer.start()
		await attack_active_timer.timeout
		attacker_state.set_state(attacker_state.AttackerState.SHEATHED)
		attack_collider.disabled = true
	
	if event.is_action_pressed("draw_blade"):
		camera_component.set_look_at_target(true)
	elif event.is_action_released("draw_blade"):
		camera_component.set_look_at_target(false)
