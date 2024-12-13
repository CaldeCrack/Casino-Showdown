class_name SlotMachine
extends RigidBody3D

@onready var timer: Timer = $Timer
@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D

func _ready() -> void:
	timer.timeout.connect(func():queue_free())
	
