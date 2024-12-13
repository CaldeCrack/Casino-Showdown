extends Hitbox


var destination: Vector3


func _ready() -> void:
	position = destination


func _on_lifespan_timeout() -> void:
	queue_free()
