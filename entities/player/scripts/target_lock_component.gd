extends Node
class_name TargetLockComponent

@onready var model: IzumiModel = %Model
@onready var camera_target: Node3D = %CameraTarget
@onready var camera_component: CameraComponent = %CameraComponent

var target: Boss

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("target_lock"):
		if target:
			lock_off()
		else:
			lock_on()

func lock_on() -> void:
	var boss := BossManager.current_boss
	if boss == null:
		return

	target = boss
	camera_component.set_look_at_target(true)

func lock_off() -> void:
	target = null
	camera_component.set_look_at_target(false)

func _physics_process(_delta: float) -> void:
	if not is_instance_valid(target):
		return

	var target_pos := (target.global_position + model.global_position) / 2.0
	camera_target.global_position = target_pos
