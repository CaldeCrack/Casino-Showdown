extends Node3D

var OWNER = get_parent()
@onready var cooldown: Timer = $Cooldown
var AVAILABLE: bool = true

var POS1 = Vector3(0,3,-4) + OWNER.position
var POS2 = Vector3(0,3,4) + OWNER.position
var POS3 = Vector3(-4,3,0) + OWNER.position
var POS4 = Vector3(4,3,0) + OWNER.position
var POS5 = Vector3(-4,3,-4) + OWNER.position
var POS6 = Vector3(4,3,-4) + OWNER.position
var POS7 = Vector3(4,3,4) + OWNER.position
var POS8 = Vector3(-4,3,4) + OWNER.position
var ARR_POS = [POS1,POS2,POS3,POS4,POS5,POS6,POS7,POS8]

var slot: PackedScene = preload("res://scenes/players/slot_machine.tscn")

func _input(event: InputEvent) -> void:
	if is_multiplayer_authority():
		if Input.is_action_just_pressed("special_attack") and AVAILABLE:
			_inst_slot.rpc()
			AVAILABLE = false
			cooldown.start()

@rpc("any_peer", "call_local")
func _inst_slot() -> void:
	for pos in ARR_POS:
		var machine: SlotMachine = slot.instantiate()
		OWNER.get_parent().add_child(machine)
		machine.global_position = OWNER.global_position + pos
		machine.collision_shape_3d.scale *= 2


func _on_cooldown_timeout() -> void:
	AVAILABLE = true
