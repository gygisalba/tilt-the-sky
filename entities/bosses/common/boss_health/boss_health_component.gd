extends HealthComponent
class_name BossHealthComponent

@onready var boss_poise: BossPoiseComponent = %BossPoiseComponent

func damage(damage: DamageInstance) -> void:
	if boss_poise.has_resource_remaining() \
		and damage.damage_type == damage.DamageType.PLAYER:
		boss_poise.decrease(damage.poise_damage)
	else:
		super(damage)
		boss_poise.resource = boss_poise.max_resource
