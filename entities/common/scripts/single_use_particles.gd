extends GPUParticles3D
class_name SingleUseParticles

func _ready() -> void:
	finished.connect(queue_free)
	one_shot = true
	emitting = true
