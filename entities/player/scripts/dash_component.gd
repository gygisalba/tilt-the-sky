extends Node
class_name DashComponent

@export var player: Player
@export var camera: PhantomCamera3D
@export var player_state: PlayerStateComponent

@export_category("Dash")
@export var dash_speed := 30.0
@export var dash_duration := 0.15
@export var dash_cooldown := 0.5
@export var dash_input := "dash"

var is_dashing := false
var can_dash := true

var dash_direction := Vector3.ZERO
var dash_timer := 0.0
var cooldown_timer := 0.0

func _physics_process(delta: float) -> void:
	if cooldown_timer > 0.0:
		cooldown_timer -= delta

	if dash_timer > 0.0:
		dash_timer -= delta

		player.velocity.x = dash_direction.x * dash_speed
		player.velocity.z = dash_direction.z * dash_speed

		if dash_timer <= 0.0:
			is_dashing = false

	if Input.is_action_just_pressed(dash_input):
		try_dash()


func try_dash() -> void:
	if !can_dash:
		return

	if is_dashing:
		return

	if player_state.is_player_state(PlayerStateComponent.PlayerState.BUSY):
		return

	var direction := get_dash_direction()

	if direction == Vector3.ZERO:
		return
	
	## TEMP FOR FUNNY
	var tween = create_tween()
	var current_degrees = player.model.rotation_degrees
	tween.tween_property(player.model, "rotation_degrees:x", current_degrees.x + 360, 0.4)
	## TEMP END

	dash_direction = direction
	is_dashing = true
	can_dash = false

	dash_timer = dash_duration
	cooldown_timer = dash_cooldown

	player.velocity.x = dash_direction.x * dash_speed
	player.velocity.z = dash_direction.z * dash_speed

	await get_tree().create_timer(dash_cooldown).timeout
	can_dash = true

func get_dash_direction() -> Vector3:
	var input := Input.get_vector(
		"move_left",
		"move_right",
		"move_forward",
		"move_backwards"
	)

	if input.length_squared() <= 0.01:
		return Vector3.ZERO

	var forward := camera.global_transform.basis.z
	var right := camera.global_transform.basis.x

	forward.y = 0.0
	right.y = 0.0

	forward = forward.normalized()
	right = right.normalized()

	return (forward * input.y + right * input.x).normalized()
