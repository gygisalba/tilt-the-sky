extends Node

## Holds a list of nodes and the tweens they are using.
var rotation_tweens : Dictionary[Node3D, Tween]

## Rotates one node towards another given node over the course of a duration using a tween.
func rotate_towards_target(
	to_rotate: Node3D, 
	rotate_towards: Node3D,
	duration: float,
	) -> void:
	var tween = rotation_tweens.get(to_rotate) as Tween
	if tween:
		tween.kill()
	
	tween = get_tree().create_tween()
	rotation_tweens[to_rotate] = tween
	
	var direction := rotate_towards.global_position - to_rotate.global_position
	direction.y = 0.0
	
	if direction.length_squared() <= 0.001:
		return
	
	direction = direction.normalized()
	
	var target_rotation := atan2(direction.x, direction.z)
	var final_rotation := to_rotate.rotation.y + angle_difference(to_rotate.rotation.y, target_rotation)
	
	tween.tween_property(to_rotate, "rotation:y", final_rotation, duration)
	tween.tween_callback(_on_rotation_finished.bind(to_rotate))

## Removes a node from the dictionary when finished rotating.
func _on_rotation_finished(to_rotate: Node3D) -> void:
	rotation_tweens.erase(to_rotate)
