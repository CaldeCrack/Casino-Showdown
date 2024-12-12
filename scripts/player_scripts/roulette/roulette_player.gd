extends Player

@onready var red_chip: bool = true

@onready var packed_red_chip = preload("res://scenes/objects/red_chip.tscn")
@onready var packed_green_chip = preload("res://scenes/objects/green_chip.tscn")
@onready var packed_special_attack = preload("res://scenes/players/special_attack_roulette.tscn")

@onready var left_marker: Marker3D = $SpecialAttack/LeftMarker
@onready var right_marker: Marker3D = $SpecialAttack/RightMarker
@onready var l_direction: Marker3D = $SpecialAttack/LeftMarker/LDirection
@onready var r_direction: Marker3D = $SpecialAttack/RightMarker/RDirection


@onready var ultimate_node: Node3D = $Ultimate
@onready var front_ultimate_marker: Marker3D = $Ultimate/FrontUltimateMarker
@onready var back_ultimate_marker: Marker3D = $Ultimate/BackUltimateMarker
@onready var left_ultimate_marker: Marker3D = $Ultimate/LeftUltimateMarker
@onready var right_ultimate_marker: Marker3D = $Ultimate/RightUltimateMarker
@onready var ultimate_effect_timer: Timer = $Ultimate/UltimateEffectTimer

var ulting: bool = false
const ULT_SPIN_SPEED: int = PI
var ULT_CHIPS: = []


func _ready() -> void:
	ultimate_effect_timer.timeout.connect(
		func():
			while len(ULT_CHIPS):
				var chip: SpecialAttackRoulette = ULT_CHIPS.pop_back()
				chip.MAX_STEP = 0
			
			ulting = false
	)


func _process(delta: float) -> void:
	if ulting:
		ultimate_node.global_rotation.y += ULT_SPIN_SPEED * delta
		print("rotation: ", ultimate_node.global_rotation)
		print("gpos: ", front_ultimate_marker.global_position)


func _input(event: InputEvent) -> void:
	if is_multiplayer_authority():
		super._input(event)
		
		if Input.is_action_just_pressed("special_attack"):
			_special_attack.rpc()
		
		if Input.is_action_just_pressed("ultimate"):
			_ultimate.rpc()


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
	
	get_parent().add_child(sp)
	sp.global_position = marker.global_position
	sp.direction = (direction.global_position - marker.global_position).normalized()
	sp.OWNER = self


@rpc("any_peer", "call_local")
func _ultimate() -> void:
	var front_chip: SpecialAttackRoulette = packed_special_attack.instantiate()
	var back_chip: SpecialAttackRoulette = packed_special_attack.instantiate()
	var left_chip: SpecialAttackRoulette = packed_special_attack.instantiate()
	var right_chip: SpecialAttackRoulette = packed_special_attack.instantiate()
	
	ULT_CHIPS.push_back(front_chip)
	ultimate_node.add_child(front_chip)
	front_chip.OWNER = self
	front_chip.fixed_to = front_ultimate_marker
	front_chip.multiplier = 0.
	front_chip.MAX_STEP = 1000
	front_chip.global_position = front_ultimate_marker.global_position
	front_chip.add_child(packed_green_chip.instantiate())
	
	ULT_CHIPS.push_back(back_chip)
	ultimate_node.add_child(back_chip)
	back_chip.OWNER = self
	back_chip.fixed_to = back_ultimate_marker
	back_chip.multiplier = 0.
	back_chip.MAX_STEP = 1000
	back_chip.global_position = back_ultimate_marker.global_position
	back_chip.add_child(packed_green_chip.instantiate())
	
	ULT_CHIPS.push_back(right_chip)
	ultimate_node.add_child(right_chip)
	right_chip.OWNER = self
	right_chip.fixed_to = right_ultimate_marker
	right_chip.multiplier = 0.
	right_chip.MAX_STEP = 1000
	right_chip.global_position = right_ultimate_marker.global_position
	right_chip.add_child(packed_red_chip.instantiate())
	
	ULT_CHIPS.push_back(left_chip)
	ultimate_node.add_child(left_chip)
	left_chip.OWNER = self
	left_chip.fixed_to = left_ultimate_marker
	left_chip.multiplier = 0.
	left_chip.MAX_STEP = 1000
	left_chip.global_position = left_ultimate_marker.global_position
	left_chip.add_child(packed_red_chip.instantiate())
	
	ulting = true
	ultimate_effect_timer.start()
