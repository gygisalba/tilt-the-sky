extends Area3D
class_name Hurtbox

@export var healthComponent: HealthComponent
@export var invincibility_timer: Timer

signal hurtbox_hit(hit_by: Hitbox)

var hitboxes_hit: Array[Hitbox] = []

func _on_area_entered(area: Area3D) -> void:
	if area is Hitbox:
		_try_damage(area)

func _on_area_exited(area: Area3D) -> void:
	if area is Hitbox:
		hitboxes_hit.erase(area)

func _try_damage(hitbox: Hitbox) -> void:
	if hitbox in hitboxes_hit:
		return

	if invincibility_timer.time_left > 0:
		return

	hitboxes_hit.append(hitbox)

	invincibility_timer.start()
	healthComponent.decrease(hitbox.damage)
	hurtbox_hit.emit(hitbox)
