extends DeathComponent
class_name BossDeathComponent

@onready var boss : Node3D = $"../.."
@onready var boss_moveset_controller: BossMovesetController = %BossMovesetController

func _on_death() -> void:
	super()
	boss_moveset_controller.stop()
	
