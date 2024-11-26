extends RigidBody3D

@onready var timer: Timer = $Timer

func _ready() -> void:
	timer.timeout.connect(func():queue_free())
