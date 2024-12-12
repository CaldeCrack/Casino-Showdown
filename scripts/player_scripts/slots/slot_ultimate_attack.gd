extends Node3D

var OWNER: Player = get_parent()
var AVAILABLE: bool = true
@onready var cooldown: Timer = $Cooldown
var slot: PackedScene = preload("res://scenes/players/slot_machine.tscn")

func _input(event: InputEvent) -> void:
	if is_multiplayer_authority():
		if Input.is_action_just_pressed("ultimate") and AVAILABLE:
			_inst_slot.rpc()
			AVAILABLE = false
			cooldown.start()

@rpc("any_peer", "call_local")
func _inst_slot() -> void:
	var machine: SlotMachine = slot.instantiate()
	OWNER.get_parent().add_child(machine)
	machine.global_position = OWNER.global_position + Vector3(0,15,-8)
	machine.collision_shape_3d.scale *= 7
	machine.rotate_y(180)
	
	# machine.rotate_z(-90)
	# machine.gravity_scale *= 2


func _on_cooldown_timeout() -> void:
	AVAILABLE = true
