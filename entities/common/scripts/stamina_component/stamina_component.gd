extends ResourceComponent
class_name StaminaComponent

var stamina: float:
	get: return resource
	set(value): resource = value

func has_stamina_remaining() -> bool:
	return has_resource_remaining()

func get_stamina_percentage() -> float:
	return get_resource_percentage()
