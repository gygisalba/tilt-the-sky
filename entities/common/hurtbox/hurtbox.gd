extends Area3D
class_name Hurtbox

@export var healthComponent : HealthComponent
@export var invincibility_timer : Timer
@export var invincibility_period := 1.00

var colliding_hitboxes : Array = []

signal hurtbox_hit(hit_by : Area3D)

func _on_area_entered(area: Area3D) -> void:
	if area is Hitbox:
		colliding_hitboxes.append(area)
 
func _on_area_exited(area: Area3D) -> void:
	if area is Hitbox:
		colliding_hitboxes.erase(area)
	
func _process(_delta: float) -> void:
	for hitbox in colliding_hitboxes:
		_damage(hitbox)

func _damage(hitbox: Hitbox) -> void:
	if invincibility_timer.time_left <= 0:
		invincibility_timer.start(invincibility_period)
		healthComponent.decrease(hitbox.damage)
		hurtbox_hit.emit(hitbox)
