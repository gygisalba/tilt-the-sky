extends Area3D
class_name Hitbox

enum DamageType {
	PLAYER,
	ENEMY,
	SLIDEABLE,
	JUMPABLE,
	PARRIABLE,
}

@export var damage : float
@export var damage_type : DamageType
