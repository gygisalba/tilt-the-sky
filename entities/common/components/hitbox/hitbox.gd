extends Area3D
class_name Hitbox

@export var hp_damage : int
@export var poise_damage : int
@export var damage_type : DamageInstance.DamageType
	
var damage_instance : DamageInstance

func _ready() -> void:
	var _damage_instance = DamageInstance.new(hp_damage, poise_damage, damage_type)
	damage_instance = _damage_instance
