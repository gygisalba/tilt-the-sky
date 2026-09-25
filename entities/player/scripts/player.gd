extends CharacterBody3D
class_name Player

@export var model : IzumiModel

func _ready() -> void:
	PlayerManager.player = self
