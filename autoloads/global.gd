extends Node

var PLAYER: Node3D

@onready var round_timer: Timer = $RoundTime
@onready var round_end_menu = $RoundEndMenu

var rng = RandomNumberGenerator.new()

func _ready() -> void:
	round_end_menu.hide()

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
