extends Node
class_name ParticlesOnHurtComponent

@onready var pure_soldier: CharacterBody3D = $"../.."
@export var health : HealthComponent
@export var particles : PackedScene

func _ready() -> void:
	health.resource_changed.connect(_on_health_changed)

func _on_health_changed(update: ResourceUpdate) -> void:
	if update.is_increase:
		return
	
	var fx : GPUParticles3D = particles.instantiate()
	pure_soldier.add_child(fx)
	fx.global_position = pure_soldier.global_position
	
