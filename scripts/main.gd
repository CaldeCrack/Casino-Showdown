extends Node3D

@export var blackjack: PackedScene
@export var dudo: PackedScene
@export var roulette: PackedScene
@export var slots: PackedScene

@onready var markers: Node3D = $Spawnpoints


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	for i in Game.players.size():
		var player_data: Statics.PlayerData = Game.players[i]
		var player_inst: Node
		match player_data.role:
			1:
				player_inst = blackjack.instantiate()
			2:
				player_inst = roulette.instantiate()
			3:
				player_inst = slots.instantiate()
			4:
				player_inst = dudo.instantiate()
		add_child(player_inst)
		player_inst.setup(player_data)
		player_inst.global_position = markers.get_child(i).global_position
	Global.round_timer.start()


func _process(_delta: float) -> void:
	pass
