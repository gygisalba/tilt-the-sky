extends Node

var player : Player
signal player_registered(player: Player)

func register(_player: Player) -> void:
	player = _player
	player_registered.emit(_player)
