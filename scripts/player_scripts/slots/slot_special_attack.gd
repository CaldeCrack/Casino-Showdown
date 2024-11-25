extends Node3D

@onready var machine: RigidBody3D = $Machine
var INIT_POS = Vector3(0,-2,-2)

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("special_attack"):
		machine.show()
		machine.gravity_scale = 1
		


func _on_machine_body_entered(body: Node) -> void:
	machine.position = INIT_POS
