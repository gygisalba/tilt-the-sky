extends BaseBossMoveTargetPlayer

var tween : Tween

func execute() -> void:
	var player_pos := get_player_pos()
	var target_pos := Vector3(
		player_pos.x,
		0.0,
		player_pos.z
	)
	
	if tween: 
		tween.kill()
	
	tween = create_tween()
	tween.tween_property(boss, "global_position", target_pos, 0.5)

func is_valid() -> bool:
	return get_player_pos().distance_to(boss.global_position) >= 3.0
