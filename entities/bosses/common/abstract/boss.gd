extends Node3D
class_name Boss

@export var boss_id : StringName

@export var boss_health : BossHealthComponent
@export var boss_poise : BossPoiseComponent

func _ready() -> void:
	BossManager.register_boss(self)
