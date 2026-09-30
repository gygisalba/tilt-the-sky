extends BaseBossMove
class_name BaseBossMoveTargetPlayer

var player : Player

func _ready() -> void:
	super()
	PlayerManager.player_registered.connect(_on_player_registered)

func _on_player_registered(_player: Player) -> void:
	player = _player

func get_player_pos() -> Vector3:
	if !is_instance_valid(player):
		player = PlayerManager.player
	
	return player.global_position
