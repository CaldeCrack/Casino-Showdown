extends Node

@onready var round_timer: Timer = $RoundTime

var rng = RandomNumberGenerator.new()

func random_int_range(from: int, to: int) -> int:
	return rng.randi_range(from, to+1)
	
func random_float_range(from: float, to: float) -> float:
	return rng.randf_range(from, to+1)
