extends Node3D

var OWNER = get_parent()

var POS1 = Vector3(0,3,-2) + OWNER.position
var POS2 = Vector3(0,3,2) + OWNER.position
var POS3 = Vector3(-2,3,0) + OWNER.position
var POS4 = Vector3(2,3,0) + OWNER.position
var POS5 = Vector3(-2,3,-2) + OWNER.position
var POS6 = Vector3(2,3,-2) + OWNER.position
var POS7 = Vector3(2,3,2) + OWNER.position
var POS8 = Vector3(-2,3,2) + OWNER.position
var ARR_POS = [POS1,POS2,POS3,POS4,POS5,POS6,POS7,POS8]

var slot: PackedScene = preload("res://scenes/players/slot_machine.tscn")

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("special_attack"):
		_inst_slot.rpc()

@rpc("any_peer", "call_local", "reliable")
func _inst_slot() -> void:
	if is_multiplayer_authority():
		for pos in ARR_POS:
			var machine = slot.instantiate()
			OWNER.get_parent().add_child(machine)
			machine.global_position = OWNER.global_position + pos
