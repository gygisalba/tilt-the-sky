extends Node
class_name TailPhysicsComponent

var skeleton: Skeleton3D
@export var player: Player

@export_category("Tail Bones")
@export var tail_bone_names: Array[StringName] = []

@export_category("Spring Physics")
@export var spring_strength := 20.0
@export var damping := 5.0

@export_category("Movement Influence")
@export var movement_influence := 0.05
@export var jump_influence := 0.3
@export var turn_influence := 0.2

@export_category("Rotation Limits")
@export var max_rotation := 0.8

@export_category("Bounce!")
@export var landing_bounce := 12.0
@export var jump_bounce := 8.0
var was_on_floor := true

var bone_indices: Array[int] = []
var bone_rest_rotations: Array[Quaternion] = []

var bone_rotations: Array[Quaternion] = []
var bone_velocities: Array[Vector3] = []

var previous_velocity := Vector3.ZERO


func _ready() -> void:
	skeleton = player.model.skeleton
	_initialize_bones()


func _initialize_bones() -> void:
	for bone_name in tail_bone_names:
		var bone_index := skeleton.find_bone(bone_name)

		if bone_index == -1:
			push_warning("Tail bone not found: " + str(bone_name))
			continue

		bone_indices.append(bone_index)

		var rest_rotation := skeleton.get_bone_pose_rotation(bone_index)

		bone_rest_rotations.append(rest_rotation)
		bone_rotations.append(rest_rotation)
		bone_velocities.append(Vector3.ZERO)


func _physics_process(delta: float) -> void:
	var velocity := player.velocity

	var acceleration = (velocity - previous_velocity) / max(delta, 0.0001)
	var local_acceleration = player.global_transform.basis.inverse() * acceleration
	previous_velocity = velocity

	_update_tail(delta, velocity, local_acceleration)
	_update_jump_impulse()
	

func _update_jump_impulse() -> void:
	var on_floor := player.is_on_floor()
	
	if was_on_floor and not on_floor:
		_apply_bounce(jump_bounce)
		
	elif not was_on_floor and on_floor:
		_apply_bounce(landing_bounce)
		
	was_on_floor = on_floor


func _update_tail(
	delta: float,
	velocity: Vector3,
	acceleration: Vector3
) -> void:
	for i in range(bone_indices.size()):
		var bone_index := bone_indices[i]
		var target_rotation := _calculate_target_rotation(
			i,
			velocity,
		)

		var current_rotation := bone_rotations[i]

		var current_euler := current_rotation.get_euler()
		var target_euler := target_rotation.get_euler()

		var spring_force := (
			target_euler - current_euler
		) * spring_strength

		bone_velocities[i] += spring_force * delta
		bone_velocities[i] *= exp(-damping * delta)

		current_euler += bone_velocities[i] * delta

		current_euler.x = clamp(
			current_euler.x,
			-max_rotation,
			max_rotation
		)

		current_euler.y = clamp(
			current_euler.y,
			-max_rotation,
			max_rotation
		)

		current_euler.z = clamp(
			current_euler.z,
			-max_rotation,
			max_rotation
		)

		bone_rotations[i] = Quaternion.from_euler(current_euler)

		skeleton.set_bone_pose_rotation(
			bone_index,
			bone_rotations[i]
		)


func _calculate_target_rotation(
	bone_index: int,
	acceleration: Vector3
) -> Quaternion:
	var movement_offset := Vector3(
		-acceleration.z * movement_influence,
		0.0,
		acceleration.x * movement_influence
	)

	var jump_offset := Vector3.ZERO

	if not player.is_on_floor():
		jump_offset.x = -jump_influence

	var turn_offset := Vector3(
		0.0,
		-acceleration.x * turn_influence,
		0.0
	)

	var offset := movement_offset + jump_offset + turn_offset

	var rest_rotation := bone_rest_rotations[bone_index]

	return rest_rotation * Quaternion.from_euler(offset)

## Helpers

func _apply_bounce(strength: float) -> void:
	for i in range(bone_velocities.size()):
		bone_velocities[i].x -= strength * (1.0 + i * 0.2)
