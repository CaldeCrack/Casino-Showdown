extends Node3D


var BASE_DAMAGE: float = 10.0
var DAMAGE: float = 10.0
@onready var OWNER = get_parent()
const SPECIAL_ATTACK_BLACKJACK = preload("res://scenes/players/special_attack_blackjack.tscn")

func _input(_event: InputEvent) -> void:
	if is_multiplayer_authority():
		if Input.is_action_just_pressed("special_attack"):
			inst_attack.rpc()


@rpc("any_peer", "call_local")
func inst_attack():
	var special_attack := SPECIAL_ATTACK_BLACKJACK.instantiate()
	special_attack.damage = DAMAGE
	add_child(special_attack)


@rpc("call_local")
func update_damage() -> void:
	DAMAGE = BASE_DAMAGE * OWNER.ATTACK
