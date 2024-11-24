extends Hitbox


func _physics_process(delta: float) -> void:
	position.z -= 12.0 * delta
