extends Node3D

@onready var machine: RigidBody3D = $Machine

func _input(event: InputEvent) -> void:
	
	if Input.is_action_just_pressed("special_attack"):
		machine.gravity_scale = 1
