extends Node3D


var rng: RandomNumberGenerator = RandomNumberGenerator.new()
var speed: float = 0.05
var x_rot: float = rng.randf_range(0.0, speed)
var y_rot: float = rng.randf_range(0.0, speed)
var z_rot: float = rng.randf_range(0.0, speed)


func _physics_process(delta: float) -> void:
	rotation += Vector3(x_rot, y_rot, z_rot)
