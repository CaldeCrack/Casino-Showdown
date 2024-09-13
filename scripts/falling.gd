extends Node2D


const SPEED: float = 60.0


func _physics_process(delta: float) -> void:
	position.y += SPEED * delta
