extends Player

@onready var red_chip: bool = true

@onready var packed_red_chip = preload("res://scenes/objects/red_chip.tscn")
@onready var packed_green_chip = preload("res://scenes/objects/green_chip.tscn")
@onready var packed_special_attack = preload("res://scenes/players/special_attack_roulette.tscn")

@onready var left_marker: Marker3D = $SpecialAttack/LeftMarker
@onready var right_marker: Marker3D = $SpecialAttack/RightMarker
@onready var l_direction: Marker3D = $SpecialAttack/LeftMarker/LDirection
@onready var r_direction: Marker3D = $SpecialAttack/RightMarker/RDirection



func _input(event: InputEvent) -> void:
	if is_multiplayer_authority():
		super._input(event)
		
		if Input.is_action_just_pressed("special_attack"):
			_special_attack.rpc()


@rpc("any_peer", "call_local")
func _special_attack() -> void:
	var chip
	var marker
	var orientation
	var direction
	
	if red_chip:
		chip = packed_red_chip
		marker = left_marker
		direction = l_direction
		orientation = -1
	else:
		chip = packed_green_chip
		marker = right_marker
		direction = r_direction
		orientation = 1
	
	red_chip = not red_chip
	
	var sp: SpecialAttackRoulette = packed_special_attack.instantiate()
	chip = chip.instantiate()
	sp.add_child(chip)
	
	sp.orientation = orientation
	chip.name = "chip"
	
	sp.global_position = marker.global_position
	sp.direction = (direction.global_position - marker.global_position).normalized()
	sp.OWNER = self
	get_parent().add_child(sp)
