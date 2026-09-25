extends Node
class_name SlideComponent

@export var player: Player
@export var camera: Camera3D
@export var state: PlayerStateComponent

@export_category("Slide Settings")
@export var minimum_steepness := 20.0
@export var minimum_slide_speed := 4.0
@export var maximum_slide_speed := 40.0
@export var minimum_slide_duration := 0.25

@export_category("Momentum")
@export var slide_start_boost := 16.0
@export var slope_acceleration := 35.0
@export var uphill_deceleration := 20.0
@export var flat_deceleration := 20.0

@export_category("Steering")
@export var steering_strength := 4.0
@export var steering_drag := 8.0

@export_category("Jumping")
@export var jump_boost := 4.0

var slide_direction := Vector3.ZERO
var slide_speed := 0.0
var slide_timer := 0.0


func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("slide"):
		start_slide()

	if not is_sliding():
		return

	if not player.is_on_floor():
		return

	update_slide_timer(delta)
	update_slide(delta)

	if Input.is_action_just_released("slide"):
		stop_slide()


func is_sliding() -> bool:
	return state.is_player_state(
		PlayerStateComponent.PlayerState.SLIDING
	)


func start_slide() -> void:
	if not player.is_on_floor():
		return

	var horizontal_velocity := Vector3(
		player.velocity.x,
		0.0,
		player.velocity.z
	)

	if horizontal_velocity.length_squared() < 0.01:
		return

	state.set_player_state(
		PlayerStateComponent.PlayerState.SLIDING
	)

	slide_speed = clampf(
		horizontal_velocity.length() + slide_start_boost,
		minimum_slide_speed,
		maximum_slide_speed
	)

	slide_direction = horizontal_velocity.normalized()
	slide_direction = project_direction_onto_floor(slide_direction)

	slide_timer = minimum_slide_duration


func update_slide(delta: float) -> void:
	var floor_normal := player.get_floor_normal()

	update_slide_momentum(delta, floor_normal)

	if should_stop_slide():
		stop_slide()
		return

	update_steering(delta, floor_normal)

	slide_direction = project_direction_onto_floor(slide_direction)

	apply_slide_velocity()


func update_slide_momentum(delta: float, floor_normal: Vector3) -> void:
	var downhill_direction := get_downhill_direction(floor_normal)
	var slope_alignment := slide_direction.dot(downhill_direction)

	var slope_angle := get_floor_angle(floor_normal)

	if slope_angle >= minimum_steepness:
		var slope_strength := sin(deg_to_rad(slope_angle))

		if slope_alignment > 0.0:
			slide_speed += (
				slope_acceleration
				* slope_strength
				* slope_alignment
				* delta
			)
		else:
			slide_speed -= (
				uphill_deceleration
				* absf(slope_alignment)
				* delta
			)
	else:
		slide_speed -= flat_deceleration * delta

	slide_speed = clampf(
		slide_speed,
		0.0,
		maximum_slide_speed
	)


func update_steering(delta: float, floor_normal: Vector3) -> void:
	var steering_input := get_steering_input()

	if steering_input.length_squared() < 0.01:
		return

	var target_direction := steering_input.slide(
		floor_normal
	).normalized()

	var steering_amount := clampf(
		steering_strength * delta,
		0.0,
		1.0
	)

	slide_direction = slide_direction.slerp(
		target_direction,
		steering_amount
	).normalized()

func apply_slide_velocity() -> void:
	var slide_velocity := slide_direction * slide_speed

	player.velocity.x = slide_velocity.x
	player.velocity.z = slide_velocity.z


func should_stop_slide() -> bool:
	return (
		slide_speed <= minimum_slide_speed
		and slide_timer <= 0.0
	)


func update_slide_timer(delta: float) -> void:
	slide_timer = maxf(
		slide_timer - delta,
		0.0
	)


func get_downhill_direction(floor_normal: Vector3) -> Vector3:
	return Vector3.DOWN.slide(
		floor_normal
	).normalized()


func get_floor_angle(floor_normal: Vector3) -> float:
	var up_dot := clampf(
		floor_normal.dot(Vector3.UP),
		-1.0,
		1.0
	)

	return rad_to_deg(acos(up_dot))


func project_direction_onto_floor(direction: Vector3) -> Vector3:
	var projected := direction.slide(
		player.get_floor_normal()
	)

	if projected.length_squared() < 0.001:
		return direction

	return projected.normalized()


func get_steering_input() -> Vector3:
	var input := Input.get_vector(
		"move_left",
		"move_right",
		"move_forward",
		"move_backwards"
	)

	var camera_basis := camera.global_basis

	var direction := (
		camera_basis.x * input.x
		+ camera_basis.z * input.y
	)

	direction.y = 0.0

	if direction.length_squared() < 0.001:
		return Vector3.ZERO

	return direction.normalized()


func get_slide_jump_velocity() -> Vector3:
	var speed_ratio := clampf(
		slide_speed / maximum_slide_speed,
		0.0,
		1.0
	)

	var forward_boost := (
		slide_direction
		* jump_boost
		* speed_ratio
	)

	var upward_boost := Vector3.UP * jump_boost

	return forward_boost + upward_boost


func apply_slide_jump() -> Vector3:
	var jump_velocity := get_slide_jump_velocity()

	stop_slide()

	return jump_velocity


func stop_slide() -> void:
	if not is_sliding():
		return

	state.set_player_state(
		PlayerStateComponent.PlayerState.IDLE
	)
