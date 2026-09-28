extends HealthComponent
class_name BossHealthComponent

@onready var boss_poise: BossPoiseComponent = %BossPoiseComponent

@export var slow_factor := 0.4
@export var slow_duration := 0.4

func damage(damage: DamageInstance) -> void:
	if boss_poise.has_resource_remaining() \
		and damage.damage_type == damage.DamageType.PLAYER:
		boss_poise.decrease(damage.poise_damage)
	else:
		super(damage)
		boss_poise.resource = boss_poise.max_resource
		Engine.time_scale = slow_factor
		await get_tree().create_timer(slow_duration, true, false, true).timeout
		Engine.time_scale = 1.0
