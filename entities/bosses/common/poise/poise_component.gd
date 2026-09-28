extends ResourceComponent
class_name PoiseComponent

var poise: float:
	get: return resource
	set(value): resource = value

func has_poise_remaining() -> bool:
	return has_resource_remaining()

func get_poise_percentage() -> float:
	return get_resource_percentage()
