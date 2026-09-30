class_name BossMovesetController
extends Node

signal move_started(move: BaseBossMove)
signal move_finished(move: BaseBossMove)

var _rng := RandomNumberGenerator.new()
var _moves: Array[BaseBossMove] = []
var _weights := PackedFloat32Array()

var _acting := false

func _ready() -> void:
	await get_tree().create_timer(1).timeout ## Delay to prevent races during testing.
	_rng.randomize()
	_collect_moves()
	start()

func _collect_moves() -> void:
	for child in get_children():
		if child is BaseBossMove:
			_moves.append(child)
			_weights.append(child.move_weight)

func start() -> void:
	if _acting:
		return
	_acting = true
	_run_loop()

func stop() -> void:
	_acting = false

func _run_loop() -> void:
	if _moves.is_empty():
		push_error("BossMovesetController has no moves to execute.")
		_acting = false
		return
	
	while _acting:
		var move := _pick_move()
		if move == null:
			await get_tree().process_frame
			continue
		await _execute(move)

func _pick_move() -> BaseBossMove:
	var valid_weights := PackedFloat32Array()
	for i in _moves.size():
		valid_weights.append(_weights[i] if _moves[i].is_valid() else 0.0)
	
	var total := 0.0
	for w in valid_weights:
		total += w
	if total <= 0.0:
		return null
	
	return _moves[_rng.rand_weighted(valid_weights)]

func _execute(move: BaseBossMove) -> void:
	if !move.is_valid():
		await get_tree().process_frame
		return
	
	move.execute()
	move_started.emit(move)
	await get_tree().create_timer(_rng.randf_range(move.min_delay, move.max_delay)).timeout
	move_finished.emit(move)
