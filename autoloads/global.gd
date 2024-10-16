extends Node

@onready var round_timer: Timer = $RoundTime

var rng = RandomNumberGenerator.new()

func random_number_range(from: int, to: int) -> int:
	return rng.randf_range(from, to+1)
	
