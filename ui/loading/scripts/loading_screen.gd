extends Control
class_name LoadingScreen

@onready var fading_panel: FadingPanel = %FadingPanel
@onready var progress_bar: ProgressBar = %ProgressBar

@export var minimum_loading_time := 1.0
var elapsed := 0.0

@export var next_scene_path: String = "res://scenes/main_scene.tscn"

var progress : Array[float] = []
signal scene_loaded

var changing_scene := false

func _ready() -> void:
	var err = ResourceLoader.load_threaded_request(next_scene_path)
	if err !=  OK:
		push_error("Failed to request scene: %s" % next_scene_path)
		queue_free()
		return
	
	progress_bar.value = progress_bar.min_value
	await fading_panel.fade_to_black(0.5)

func _process(delta: float) -> void:
	if changing_scene:
		return
	
	elapsed += delta
	
	var status = ResourceLoader.load_threaded_get_status(next_scene_path, progress)
	
	match status:
		ResourceLoader.THREAD_LOAD_IN_PROGRESS:
			var pct = progress[0] * 100
			var tween = get_tree().create_tween()
			tween.tween_property(progress_bar, "value", pct, 0.25)
		
		ResourceLoader.THREAD_LOAD_LOADED:
			if elapsed < minimum_loading_time:
				return
			
			var tween = get_tree().create_tween()
			tween.tween_property(progress_bar, "value", progress_bar.max_value, 0.25)
			
			changing_scene = true
			set_process(false)
			
			var scene = ResourceLoader.load_threaded_get(next_scene_path) as PackedScene
			
			if scene == null:
				push_error("Failed to get loaded scene: %s" % next_scene_path)
				queue_free()
				return
			
			var err = get_tree().change_scene_to_packed(scene)
			if err:
				push_error("Failed to change scene: %s" % next_scene_path)
				queue_free()
				return
			
			await fading_panel.fade_to_clear(0.5)
			
			scene_loaded.emit()
			queue_free()
			
		ResourceLoader.THREAD_LOAD_FAILED, ResourceLoader.THREAD_LOAD_INVALID_RESOURCE:
			push_error("Failed to load scene: %s" % next_scene_path)
			queue_free()
