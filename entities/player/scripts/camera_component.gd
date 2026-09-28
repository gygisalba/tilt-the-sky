extends Node
class_name CameraComponent

@onready var camera_pivot: Node3D = %CameraPivot
@onready var camera: PhantomCamera3D = %PhantomCamera3D
@onready var model: IzumiModel = %Model
@onready var camera_target: Node3D = %CameraTarget
@onready var target_lock: TargetLockComponent = %TargetLockComponent

@export_category("Mouse Look")
@export var look_distance := 4.0
@export var look_smoothing := 10.0
@export var mouse_deadzone := 0.05

@export_category("Target Follow")
@export var rotation_speed := 12.0
var following_target := false

func _process(delta: float) -> void:
	if following_target:
		_handle_follow(delta)
	
	if is_instance_valid(target_lock.target):
		return
	
	var viewport_size := get_viewport().get_visible_rect().size
	var mouse_position := get_viewport().get_mouse_position()

	var screen_center := viewport_size * 0.5
	var mouse_offset := mouse_position - screen_center

	var normalized_offset := Vector2(
		mouse_offset.x / screen_center.x,
		mouse_offset.y / screen_center.y
	)

	if normalized_offset.length() < mouse_deadzone:
		normalized_offset = Vector2.ZERO

	normalized_offset = normalized_offset.limit_length(1.0)

	var target_offset := Vector3(
		normalized_offset.x,
		0.0,
		normalized_offset.y
	) * look_distance

	var desired_position := player_position() + target_offset

	camera_target.global_position = camera_target.global_position.lerp(
		desired_position,
		1.0 - exp(-look_smoothing * delta)
	)
	
func _handle_follow(delta: float) -> void:
	var direction := camera_target.global_position - model.global_position
	direction.y = 0.0

	if direction.length_squared() <= 0.001:
		return

	direction = direction.normalized()

	var target_rotation := atan2(direction.x, direction.z)

	model.rotation.y = lerp_angle(
		model.rotation.y,
		target_rotation,
		rotation_speed * delta
	)
	
func player_position() -> Vector3:
	return model.global_position

func set_look_at_target(state: bool) -> void:
	following_target = state
