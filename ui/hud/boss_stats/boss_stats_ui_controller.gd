extends Node
class_name BossStatsUIController

@onready var poise_bar: ProgressBar = %PoiseBar
@onready var health_chunks: Array[ProgressBar] = [
	%HealthChunk1,
	%HealthChunk2,
	%HealthChunk3,
]

@export var tween_duration := 0.5
@export var transition_type := Tween.TransitionType.TRANS_CIRC
@export var ease_type := Tween.EaseType.EASE_IN

var poise_tween: Tween
var health_tweens: Array[Tween] = []


func _ready() -> void:
	BossManager.boss_registered.connect(_on_boss_registered)
	health_tweens.resize(health_chunks.size())

func _on_boss_registered(_boss: Boss) -> void:
	var boss = _boss

	boss.boss_health.resource_changed.connect(_on_health_changed)
	boss.boss_poise.resource_changed.connect(_on_poise_changed)

	_update_health(boss.boss_health.health)
	_update_poise(boss.boss_poise.poise)

func _on_health_changed(update: ResourceUpdate) -> void:
	_update_health(update.current_value)

func _on_poise_changed(update: ResourceUpdate) -> void:
	_update_poise(update.current_value)


func _update_health(health: float) -> void:
	for i in health_chunks.size():
		var value := 1.0 if health >= i + 1 else 0.0
		_update_hud(health_chunks[i], value, health_tweens, i)

func _update_poise(poise: float) -> void:
	if poise_tween:
		poise_tween.kill()

	poise_tween = _tween_bar(poise_bar, poise)


func _update_hud(bar: ProgressBar,
	new_value: float,
	tweens: Array[Tween],
	index: int ) -> void:
		
	if tweens[index]:
		tweens[index].kill()

	tweens[index] = _tween_bar(bar, new_value)


func _tween_bar(bar: ProgressBar, new_value: float) -> Tween:
	var tween := get_tree().create_tween()
	tween.set_ease(ease_type)
	tween.set_trans(transition_type)
	tween.tween_property(bar, "value", new_value, tween_duration)
	return tween
