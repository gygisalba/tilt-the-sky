extends Node
class_name BaseBossMove

## The ID of the move.
@export var move_id := &"BaseBossMoveID"

## How heavily weighted this move is to be used.
## Higher weight means higher odds. (0.0 = Never)
@export var move_weight := 1.0

@export_category("Move Statistics")
## How long (in seconds) will the boss pause after using this attack.
@export var min_delay := 1.0
@export var max_delay := 3.0

var boss : Boss

## Emitted when the boss does not meet the requirements to use the move.
## Causes the moveset controller to immediately pick a new one.
signal InvalidMove()

func _ready() -> void:
	BossManager.boss_registered.connect(_on_boss_registered)

func _on_boss_registered(_boss: Boss) -> void:
	boss = _boss

## To be overwritten
func execute() -> void:
	pass

## To be overwritten
func is_valid() -> bool:
	return true
