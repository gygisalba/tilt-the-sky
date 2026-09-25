extends Node
class_name CameraComponent

@export var camera : PhantomCamera3D
@export var camera_pivot : Node3D
@export var model : Node3D

@export_range(0.0, 1.0) var mouse_sensitivity := 0.04
@export var tilt_limit := deg_to_rad(75)

@export var min_zoom := 0.5
@export var max_zoom := 5.0
@export var zoom_speed := 10.0
@export var zoom_increment := 0.1

@export var zoom_target := 1.0

func _ready() -> void:
	zoom_target = camera.get_spring_length()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event: InputEvent) -> void:
	if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
		return
	
	handle_rotation(event)
	handle_zoom(event)

func handle_rotation(event: InputEvent) -> void:
	if event is not InputEventMouseMotion:
		return
	
	var current_rotation = camera.get_third_person_rotation()
	
	var target_pitch = current_rotation.x - event.relative.y * mouse_sensitivity * 0.1
	var target_yaw   = current_rotation.y - event.relative.x * mouse_sensitivity * 0.1
	
	target_pitch = clamp(target_pitch, deg_to_rad(-89.0), deg_to_rad(89.0))
	
	var target_rotation = Vector3(target_pitch, target_yaw, 0.0)
	camera.set_third_person_rotation(target_rotation)

func handle_zoom(event: InputEvent) -> void:
	if event.is_action_pressed("camera_zoom_in"):
		zoom_target =  clampf((zoom_target - zoom_increment), min_zoom, max_zoom)
	elif event.is_action_pressed("camera_zoom_out"):
		zoom_target =  clampf((zoom_target + zoom_increment), min_zoom, max_zoom)

func _process(delta: float) -> void:
	var spring_length = camera.get_spring_length()
	camera.set_spring_length(lerpf(spring_length, zoom_target, zoom_speed * delta))
