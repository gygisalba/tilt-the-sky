extends ColorRect
class_name FadingPanel

## Makes the panel clear over the span of the duration.
func fade_to_clear(duration: float) -> void:
	self_modulate.a = 1.0
	var tween = create_tween()
	tween.tween_property(self, "self_modulate:a", 0.0, duration)
	await tween.finished

## Makes the panel black over the span of the duration.
func fade_to_black(duration: float) -> void:
	self_modulate.a = 0.0
	var tween = create_tween()
	tween.tween_property(self, "self_modulate:a", 1.0, duration)
	await tween.finished
	
