extends Resource
class_name DamageInstance

enum DamageType {
	PLAYER,
	ENEMY,
	SLIDEABLE,
	JUMPABLE,
	PARRIABLE,
}

@export var health_damage : int
@export var poise_damage : int
@export var damage_type : DamageType = DamageType.ENEMY

func _init(init_health_damage: int, init_poise_damage: int, init_damage_type: DamageType) -> void:
	health_damage = init_health_damage
	poise_damage = init_poise_damage
	damage_type = init_damage_type
