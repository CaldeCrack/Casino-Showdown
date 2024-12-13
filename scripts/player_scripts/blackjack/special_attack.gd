extends Node3D


const SPECIAL_ATTACK_BLACKJACK = preload("res://scenes/players/special_attack_blackjack.tscn")
var BASE_DAMAGE: float = 50.0
var DAMAGE: float = BASE_DAMAGE
var AVAILABLE: bool = true
@onready var OWNER = get_parent()
@onready var cd: Timer = $CD


func _input(_event: InputEvent) -> void:
	if is_multiplayer_authority():
		if Input.is_action_just_pressed("special_attack") and AVAILABLE:
			_inst_attack.rpc()
			AVAILABLE = false
			cd.start()


@rpc("any_peer", "call_local")
func _inst_attack():
	var special_attack := SPECIAL_ATTACK_BLACKJACK.instantiate()
	special_attack.initial_position = OWNER.global_position - Vector3(0, 0.1, 0)
	special_attack.moving_to = OWNER.looking_at.global_position
	special_attack.damage = DAMAGE
	add_child(special_attack)


@rpc("call_local")
func update_damage() -> void:
	DAMAGE = BASE_DAMAGE * OWNER.ATTACK


func _on_cd_timeout() -> void:
	default()

func default() -> void:
	AVAILABLE = true
