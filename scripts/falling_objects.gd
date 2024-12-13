extends Node2D


@onready var spawner_cd: Timer = $SpawnerCD
var falling := preload("res://scenes/falling.tscn")


func _ready() -> void:
	if get_parent().name in ["Menu", "Lobby", "Credits", "Options"]:
		var y_pos: float =  get_viewport().size.y
		for i in range(4):
			var x_pos: float = Global.rng.randf_range(0.0, get_viewport().size.x)
			inst(x_pos, y_pos)
			y_pos -= 300


func inst(x_pos: float, y_pos: float = -300) -> void:
	var falling_inst := falling.instantiate()
	falling_inst.position.x = x_pos
	falling_inst.position.y = y_pos
	add_child(falling_inst)


func _on_spawner_cd_timeout() -> void:
	if get_parent().name in ["Menu", "Lobby", "Credits", "Options"]:
		var x_pos: float = Global.rng.randf_range(-200.0, get_viewport().size.x + 200)
		inst(x_pos)


func _on_delete_border_area_entered(area: Area2D) -> void:
	area.queue_free()
