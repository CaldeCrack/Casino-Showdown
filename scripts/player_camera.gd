extends Camera3D


@onready var looking_at: Marker3D = $"../SpringArm3D/LookingAt"


func _process(_delta: float) -> void:
	if is_multiplayer_authority():
		make_current()
		look_at(looking_at.global_position)
