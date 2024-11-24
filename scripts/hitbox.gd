class_name Hitbox
extends Area3D

signal damage_dealt()

@export var damage: float = 50.0
var BASE_DAMAGE: float = damage
@onready var OWNER = get_parent().get_parent()


@rpc("call_local")
func update_damage() -> void:
	damage = BASE_DAMAGE * OWNER.ATTACK
