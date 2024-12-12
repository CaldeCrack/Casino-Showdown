extends Node3D


const SPECIAL_ATTACK_BLACKJACK = preload("res://scenes/players/special_attack_blackjack.tscn")
const EXPLOSION = preload("res://scenes/explosion.tscn")
var BASE_DAMAGE: float = 15.0
var DAMAGE: float = BASE_DAMAGE
var AVAILABLE: bool = true
var plays: Array[int] = []
var play: int = 0
var throwed: int = 0
var throwing: bool = false
@onready var OWNER = get_parent()
@onready var cd: Timer = $CD
@onready var can_throw: Timer = $CanThrow
@onready var play_label: Label = $"../UI/MarginContainer/Crosshair/PlayLabel"
@onready var label_reset: Timer = $LabelReset


func _input(_event: InputEvent) -> void:
	if is_multiplayer_authority():
		if Input.is_action_just_pressed("ultimate") and AVAILABLE and \
										0 <= throwed and throwed <= 4:
			_inst_attack.rpc()
			if not throwing:
				can_throw.start()
				throwing = true
			if throwed == 4:
				_best_play()
				_inst_explosion.rpc()
				cd.start()
				AVAILABLE = false
				label_reset.start()
				can_throw.stop()


@rpc("any_peer", "call_local")
func _inst_attack():
	var ultimate := SPECIAL_ATTACK_BLACKJACK.instantiate()
	ultimate.initial_position = OWNER.global_position - Vector3(0, 0.1, 0)
	ultimate.moving_to = OWNER.looking_at.global_position
	ultimate.damage = DAMAGE
	add_child(ultimate)
	throwed += 1
	plays.append(min(ultimate.card.rank, 10))
	play_label.text = str(plays.reduce(func(accum, val): return accum + val, 0))


@rpc("any_peer", "call_local")
func _inst_explosion():
	var explosion := EXPLOSION.instantiate()
	explosion.destination = OWNER.looking_at.global_position
	explosion.damage = DAMAGE * play / 7.0
	add_child(explosion)


@rpc("call_local")
func update_damage() -> void:
	DAMAGE = BASE_DAMAGE * OWNER.ATTACK


func _on_cd_timeout() -> void:
	default()


func _on_can_throw_timeout() -> void:
	_best_play()
	_inst_explosion.rpc()
	cd.start()
	AVAILABLE = false
	throwing = false
	throwed = 0
	label_reset.start()


func _best_play():
	var best_play: int = plays.reduce(func(accum, val): return accum + val, 0)
	for rank in plays:
		if rank == 1 and best_play <= 11:
			best_play += 10
	if best_play > 21:
		best_play = 0
	elif best_play == 21 and len(plays) == 2:
		best_play = 28
	play_label.text = str(best_play)
	update_stat_rpc.rpc("play", best_play)


@rpc("any_peer", "call_remote", "reliable")
func update_stat_rpc(stat: String, value: int) -> void:
	set(stat, value)


func default() -> void:
	play_label.text = ''
	AVAILABLE = true
	plays = []
	play = 0
	throwed = 0
	throwing = false


func _on_label_reset_timeout() -> void:
	play_label.text = ''
