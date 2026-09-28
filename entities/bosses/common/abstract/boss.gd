extends CharacterBody3D
class_name Boss

@export var boss_id : StringName

func _ready() -> void:
	BossManager.register_boss(self)
