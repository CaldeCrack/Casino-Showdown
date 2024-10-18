extends Node3D

@export var player_scene: PackedScene
@onready var markers: Node3D = $Spawnpoints


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	for i in Game.players.size():
		var player_data: Statics.PlayerData = Game.players[i]
		var player_inst: Node = player_scene.instantiate()
		add_child(player_inst)
		player_inst.setup(player_data)
		# player_inst.SPAWNPOINT = markers.get_child(i).global_position
		player_inst.global_position = markers.get_child(i).global_position
	Global.round_timer.start()


func _process(delta: float) -> void:
	pass
