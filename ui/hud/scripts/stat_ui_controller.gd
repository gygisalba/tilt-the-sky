extends Node
class_name StatsUIController

@onready var health: HealthComponent = %HealthComponent
@onready var health_bar: ProgressBar = %HealthBar

@export var progress_tween_duration := 0.2

var tween : Tween

func _ready() -> void:
	health.resource_changed.connect(_on_health_changed)
	health.initialize_resource()

func _on_health_changed(update: ResourceUpdate) -> void:
	if tween:
		tween.kill()
	
	tween = get_tree().create_tween()
	tween.tween_property(
		health_bar, 
		"value", 
		update.current_value, 
		progress_tween_duration
	)
