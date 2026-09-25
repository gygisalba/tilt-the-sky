extends Node
class_name MovementComponent

@export var player: CharacterBody3D
@export var camera: PhantomCamera3D
@export var model: Node3D
@export var player_state: PlayerStateComponent
@export var jump: JumpComponent
@export var speed_modifier: MovementSpeedModifierComponent

@export_category("Movement")
@export var base_speed := 25.0
@export var acceleration := 80.0
@export var deceleration := 100.0

@export_category("Air Movement")
@export var air_acceleration := 30.0
@export var air_steering := 8.0
@export var air_max_speed := 25.0

var current_speed : float

@export_category("Rotation")
@export var rotation_lerp_speed := 0.25

@export_category("Noclip")
@export var noclip_speed := 10.0

signal air_state_changed(is_airborne: bool)
var airborne := false

func _ready() -> void:
	current_speed = base_speed
	speed_modifier.movement_speed_modifiers_updated.connect(_on_movement_speed_modifiers_updated)

func _on_movement_speed_modifiers_updated(modifiers: Dictionary) -> void:
	current_speed = base_speed
	if modifiers.is_empty():
		return
	
	var total_modifier := 0.0
	for modifier in modifiers.values():
		total_modifier += modifier
	
	current_speed = base_speed * total_modifier
	
func _physics_process(delta: float) -> void:
	jump.handle_jumping(
		player.is_on_floor(),
		delta
	)

	if player_state.is_player_state(
		PlayerStateComponent.PlayerState.IDLE
	):
		get_move_input(delta)

	player.move_and_slide()

	update_air_state()

func update_air_state() -> void:
	var new_airborne := not player.is_on_floor()

	if airborne == new_airborne:
		return

	airborne = new_airborne
	air_state_changed.emit(airborne)

func get_move_input(delta: float) -> void:
	var input := Input.get_vector(
		"move_left",
		"move_right",
		"move_forward",
		"move_backwards"
	)

	var dir := Vector3.ZERO

	if input.length_squared() > 0.01:
		var forward := camera.global_transform.basis.z
		var right := camera.global_transform.basis.x

		forward.y = 0.0
		right.y = 0.0

		forward = forward.normalized()
		right = right.normalized()

		dir = (forward * input.y + right * input.x).normalized()

		var target_yaw := atan2(dir.x, dir.z)

		model.rotation.y = lerp_angle(
			model.rotation.y,
			target_yaw,
			1.0 - exp(-10.0 * delta)
		)

	var horizontal_velocity := Vector3(
		player.velocity.x,
		0.0,
		player.velocity.z
	)

	if player.is_on_floor():
		var target_velocity := dir * current_speed

		var rate := (
			acceleration
			if dir != Vector3.ZERO
			else deceleration
		)

		horizontal_velocity.x = move_toward(
			horizontal_velocity.x,
			target_velocity.x,
			rate * delta
		)

		horizontal_velocity.z = move_toward(
			horizontal_velocity.z,
			target_velocity.z,
			rate * delta
		)
	else:
		horizontal_velocity = apply_air_control(
			horizontal_velocity,
			dir,
			delta
		)

	player.velocity.x = horizontal_velocity.x
	player.velocity.z = horizontal_velocity.z


func apply_air_control(
	velocity: Vector3,
	direction: Vector3,
	delta: float
) -> Vector3:
	if direction == Vector3.ZERO:
		return velocity

	var directional_speed := velocity.dot(direction)

	if directional_speed < air_max_speed:
		var acceleration_amount := air_acceleration * delta
		acceleration_amount = minf(
			acceleration_amount,
			air_max_speed - directional_speed
		)

		velocity += direction * acceleration_amount

	var horizontal_speed := velocity.length()

	if horizontal_speed > 0.01:
		var desired_velocity := direction * horizontal_speed

		velocity = velocity.lerp(
			desired_velocity,
			1.0 - exp(-air_steering * delta)
		)

	return velocity
