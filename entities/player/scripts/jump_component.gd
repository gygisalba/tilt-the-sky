extends Node
class_name JumpComponent

@export var player : Player
@export var player_state : PlayerStateComponent
@export var slide : SlideComponent

@export_category("Jump")
@export var jump_speed := 20.0
@export var jump_gravity := 30.0
@export var fall_gravity := 45.0
@export var double_jump_speed := 18.0
@export var double_jump_gravity := 40.0
@export var double_fall_gravity := 60.0
@export var jump_cut_multiplier := 0.4
@export var coyote_time := 0.12
@export var jump_buffer_time := 0.12
@export var max_air_jumps := 2
@export var max_wall_jumps := 3
@export var wall_jump_horizontal_speed := 18.0

var coyote_timer := 0.0
var jump_buffer_timer := 0.0
var air_jumps_left : int
var wall_jumps_left : int
var is_double_jumping := false

func _ready() -> void:
	air_jumps_left = max_air_jumps
	wall_jumps_left = max_wall_jumps

func handle_jumping(on_floor: bool, delta: float) -> void:
	if on_floor:
		slide.handle_slide()
		coyote_timer = coyote_time
		air_jumps_left = max_air_jumps
		wall_jumps_left = max_wall_jumps
		is_double_jumping = false
	else:
		coyote_timer = max(coyote_timer - delta, 0.0)
	
	if Input.is_action_just_pressed("jump"):
		jump_buffer_timer = jump_buffer_time
	else:
		jump_buffer_timer = max(jump_buffer_timer - delta, 0.0)

	jump(on_floor)

	if !on_floor and !player_state.is_player_state(PlayerStateComponent.PlayerState.MANTLING):
		if player.velocity.y > 0.0:
			var gravity := (
				double_jump_gravity
				if is_double_jumping
				else jump_gravity)
			player.velocity.y -= gravity * delta
		else:
			var gravity := (
			double_fall_gravity
			if is_double_jumping
			else fall_gravity)
			player.velocity.y -= gravity * delta

	if Input.is_action_just_released("jump") and player.velocity.y > 0.0:
		player.velocity.y *= jump_cut_multiplier

func jump(on_floor: bool) -> void:
	if jump_buffer_timer <= 0.0:
		return

	if coyote_timer > 0.0:
		player.velocity.y = jump_speed
		air_jumps_left -= 1
		coyote_timer = 0.0
		jump_buffer_timer = 0.0
		is_double_jumping = false
		if player_state.is_player_state(player_state.PlayerState.SLIDING):
			var boost_dir := slide.slide_direction
			boost_dir.y = 0.0
			if boost_dir.length_squared() > 0.0001:
				boost_dir = boost_dir.normalized()
				var boosted_speed := slide.slide_speed + slide.jump_boost
				player.velocity.x = boost_dir.x * boosted_speed
				player.velocity.z = boost_dir.z * boosted_speed
				player_state.set_player_state(player_state.PlayerState.IDLE)
		return
		
	if !on_floor:
		if player.is_on_wall_only() and wall_jumps_left > 0:
			wall_jump()
		elif air_jumps_left > 0:
			player.velocity.y = double_jump_speed
			air_jumps_left -= 1
			jump_buffer_timer = 0.0
			is_double_jumping = true

func wall_jump() -> void:
	var wall_normal := player.get_wall_normal()
	var push_direction := Vector3(wall_normal.x, 0.0, wall_normal.z).normalized()
	
	player.velocity.x += push_direction.x * wall_jump_horizontal_speed
	player.velocity.z += push_direction.z * wall_jump_horizontal_speed
	player.velocity.y = wall_jump_horizontal_speed
	
	wall_jumps_left -= 1
	jump_buffer_timer = 0.0
	is_double_jumping = false
