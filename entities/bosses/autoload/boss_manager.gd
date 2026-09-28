extends Node

var current_boss : Boss

func register_boss(boss: Boss) -> void:
	current_boss = boss

func clear_boss() -> void:
	current_boss = null
