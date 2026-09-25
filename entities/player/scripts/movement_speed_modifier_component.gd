extends Node
class_name MovementSpeedModifierComponent

signal movement_speed_modifiers_updated(modifiers: Dictionary)
var movement_speed_modifiers : Dictionary = {}

## Returns all modifiers in the dictionary.
func get_modifiers() -> Dictionary:
	return movement_speed_modifiers

## Gets a modifier by it's identifier string, returning "1.0" if it doesn't exist.
func get_modifier(identifier: String) -> float:
	var modifier = movement_speed_modifiers.get(identifier)
	if modifier == null:
		return 1.0
	
	return modifier

## Adds a modifier to the dictionary.
func add_modifier(identifier: String, modifier: float) -> void:
	movement_speed_modifiers[identifier] = modifier
	movement_speed_modifiers_updated.emit(movement_speed_modifiers)

## Removes a modifier by identifier.
func remove_modifier(identifier: String) -> void:
	movement_speed_modifiers.erase(identifier)
	movement_speed_modifiers_updated.emit(movement_speed_modifiers)

## Clears all modifiers from the dictionary.
func clear_modifiers() -> void:
	movement_speed_modifiers.clear()
	movement_speed_modifiers_updated.emit(movement_speed_modifiers)
