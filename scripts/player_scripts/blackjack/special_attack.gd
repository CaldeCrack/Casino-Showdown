extends Node3D


const SPECIAL_ATTACK_BLACKJACK = preload("res://scenes/players/special_attack_blackjack.tscn")

func _input(event: InputEvent) -> void:
	if is_multiplayer_authority():
		if Input.is_action_just_pressed("special_attack"):
			inst_attack.rpc()


@rpc("any_peer", "call_local")
func inst_attack():
	var special_attack := SPECIAL_ATTACK_BLACKJACK.instantiate()
	add_child(special_attack)
