extends RefCounted
class_name ResourceUpdate

var previous_value : float
var current_value : float
var max_value : float

var resource_percentage: float:
	get:
		if max_value <= 0:
			return 0.0
		return clampf(current_value / max_value, 0.0, 1.0)

var is_increase: bool:
	get:
		return current_value > previous_value

var delta: float:
	get:
		return current_value - previous_value

var absolute_delta: float:
	get:
		return abs(delta)
