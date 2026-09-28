extends Node
class_name ParticlesOnResourceChangeomponent

@export var character : Node3D
@export var resources : Array[ResourceComponent]
@export var particles : PackedScene

func _ready() -> void:
	for resource in resources:
		resource.resource_changed.connect(_on_resource_changed)

func _on_resource_changed(update: ResourceUpdate) -> void:
	if update.is_increase:
		return
	
	var fx : GPUParticles3D = particles.instantiate()
	character.add_child(fx)
	fx.global_position = character.global_position
	
