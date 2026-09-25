extends Node
class_name ResourceComponent

signal resource_changed(ResourceUpdate)

@export var max_resource := 100.0
var _resource := 0.0

@export var start_at_max := true

var resource: float:
	get: return _resource
	set(value): _set_resource(value)

func _ready() -> void:
	initialize_resource()

func initialize_resource() -> void:
	if start_at_max:
		resource = max_resource

func decrease(amount: float) -> void:
	resource -= amount

func increase(amount: float) -> void:
	decrease(-amount)

func set_max_resource(amount: float) -> void:
	max_resource = amount
	if resource > max_resource:
		resource = max_resource

func _get_resource() -> float:
	return resource

# to be overridden
func _set_resource(value: float) -> void:
	var resource_update = ResourceUpdate.new()
	resource_update.MaxValue = max_resource
	resource_update.PreviousValue = resource
	
	_resource = clampf(value, 0.0, max_resource)
	resource_update.CurrentValue = resource
	
	resource_changed.emit(resource_update)
	
func has_resource_remaining() -> bool:
	return resource > 0

func get_resource_percentage() -> float:
	if resource <= 0:
		return 0.0
	return clampf(resource / max_resource, 0.0, 1.0)
