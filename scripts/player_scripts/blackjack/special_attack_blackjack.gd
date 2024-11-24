extends Hitbox


var initial_position: Vector3
var moving_to: Vector3
var direction: Vector3
const SPEED: float = 25.0


func _ready() -> void:
	position = initial_position
	direction = (moving_to - initial_position).normalized()


func _physics_process(delta: float) -> void:
	position += direction * SPEED * delta
	look_at(moving_to)


func _on_damage_dealt() -> void:
	queue_free()


func _on_lifespan_timeout() -> void:
	queue_free()


func _on_body_entered(body: Node3D) -> void:
	if body.get_parent().get_parent() != get_parent().get_parent():
		queue_free()
