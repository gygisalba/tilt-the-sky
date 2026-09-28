extends Node
class_name DeathComponent

@export var health : HealthComponent

signal death()

func _ready() -> void:
	health.resource_changed.connect(_on_health_updated)

func _on_health_updated(update: ResourceUpdate) -> void:
	if update.current_value <= 0:
		_on_death()

## To be overridden
func _on_death() -> void:
	death.emit()
