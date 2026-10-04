extends Node
class_name BaseBossMove

## The ID of the move.
@export var move_id := &"BaseBossMoveID"

## How heavily weighted this move is to be used.
## Higher weight means higher odds. (0.0 = Never)
@export var move_weight := 1.0

@export_category("Move Statistics")
## The minimum duration (in seconds) the boss will pause for after using this attack.
@export var min_delay := 1.0
## The maximum duration (in seconds) the boss will pause for after using this attack.
@export var max_delay := 3.0

## The boss using this move.
var boss : Boss

## Used by a lot of moves, so here to prevent repetition.
var tween : Tween

## Emitted when the boss does not meet the requirements to use the move.
## Causes the moveset controller to immediately pick a new one.
signal InvalidMove()

func _ready() -> void:
	BossManager.boss_registered.connect(_on_boss_registered)

func _on_boss_registered(_boss: Boss) -> void:
	boss = _boss

## To be overwritten.
func execute() -> void:
	pass

## To be overwritten.
func is_valid() -> bool:
	return true
