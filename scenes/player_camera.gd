extends Camera3D


func _process(delta: float) -> void:
	if is_multiplayer_authority():
		make_current()
