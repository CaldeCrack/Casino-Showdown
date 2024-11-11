extends Node

var PLAYER
var ROUNDS: int = 0
var round_rdy = {}
var rng = RandomNumberGenerator.new()
var player_count = 0

@onready var round_timer: Timer = $RoundTime

func _ready() -> void:
	pass

func random_int_range(from: int, to: int) -> int:
	return rng.randi_range(from, to+1)


func random_float_range(from: float, to: float) -> float:
	return rng.randf_range(from, to+1)


func slot(stat: float) -> float:
	var number_one: int = random_int_range(1,4)
	var number_two: int = random_int_range(1,4)
	var number_three: int = random_int_range(1,4)
	
	if number_one == number_two and number_one == number_three:
		return stat * 1.5
	
	elif number_one == number_two:
		return stat * 1.25
	
	elif number_one == number_three:
		return stat * 1.25
	
	elif number_two == number_three:
		return stat * 1.25
	
	else:
		return stat * 0.75

func count_players() -> int:
	player_count = len(Game.players)
	return player_count
