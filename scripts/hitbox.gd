class_name Hitbox
extends Area3D

signal damage_dealt()


@export var damage: float = 50.0

@rpc
func set_damage(n: float) -> void:
	damage *= n
