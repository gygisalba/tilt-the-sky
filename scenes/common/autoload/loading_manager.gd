extends Node

const LOADING_SCREEN = preload("uid://bj1a42embcbvg")
signal scene_loaded

func load_scene(scene: String) -> void:
	var loading = LOADING_SCREEN.instantiate()
	loading.next_scene_path = scene
	
	get_tree().root.add_child(loading)
	
	await loading.scene_loaded
	scene_loaded.emit()
