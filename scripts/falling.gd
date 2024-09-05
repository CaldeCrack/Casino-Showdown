extends Node2D


const SPEED: float = 2.0


func _physics_process(delta: float) -> void:
	position.y += SPEED
