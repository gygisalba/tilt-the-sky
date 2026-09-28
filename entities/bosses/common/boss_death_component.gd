extends DeathComponent
class_name BossDeathComponent
@onready var pure_soldier: CharacterBody3D = $"../.."

func _on_death() -> void:
	super()
	pure_soldier.queue_free()
	
