extends Node
class_name TargetLockComponent

@onready var model: IzumiModel = %Model
@onready var camera_focus: Node3D = %CameraFocus
@onready var target_lock_camera_focus: Node3D = %TargetLockCameraFocus
@onready var camera_component: CameraComponent = %CameraComponent
@onready var camera: PhantomCamera3D = %PhantomCamera3D

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
	camera.follow_target = target_lock_camera_focus
	camera_component.set_look_at_target(target_lock_camera_focus)

func lock_off() -> void:
	target = null
	camera_component.set_look_at_target(camera_focus)
	camera.follow_target = camera_focus

func _physics_process(_delta: float) -> void:
	if not is_instance_valid(target):
		return

	var target_pos := (target.global_position + model.global_position) / 2.0
	target_lock_camera_focus.global_position = target_pos
