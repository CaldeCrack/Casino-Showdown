extends Node3D


var INIT_POS = Vector3(0,3,-2)
var OWNER = get_parent()
var slot: PackedScene = preload("res://scenes/players/slot_machine.tscn")


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("special_attack"):
		_inst_slot.rpc()

@rpc("any_peer", "call_local")
func _inst_slot() -> void:
	var machine = slot.instantiate()
	OWNER.get_parent().add_child(machine)
	machine.global_position = OWNER.global_position + INIT_POS
