extends Control

func _on_start_pressed() -> void:
	LoadingManager.load_scene("res://scenes/main_scene.tscn")

func _on_options_pressed() -> void:
	pass # add options later

func _on_quit_pressed() -> void:
	get_tree().quit() # this should do a "Are you sure? Azumi will miss you!" later
