extends Node

var current_boss : Boss

signal boss_registered()

func register_boss(boss: Boss) -> void:
	current_boss = boss
	boss_registered.emit()

func clear_boss() -> void:
	current_boss = null
