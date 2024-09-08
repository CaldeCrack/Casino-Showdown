extends Control


@onready var falling_objects: Node2D = $FallingObjects

var rng: RandomNumberGenerator = RandomNumberGenerator.new()
var falling := preload("res://scenes/falling.tscn")


func _ready() -> void:
	var y_pos: float =  get_viewport().size.y
	for i in range(4):
		var x_pos: float = rng.randf_range(0.0, get_viewport().size.x)
		inst(x_pos, y_pos)
		y_pos -= 300


func _on_timer_timeout() -> void:
	var x_pos: float = rng.randf_range(-200.0, get_viewport().size.x + 200)
	inst(x_pos)


func inst(x_pos: float, y_pos: float = -300) -> void:
	var falling_inst := falling.instantiate()
	falling_inst.position.x = x_pos
	falling_inst.position.y = y_pos
	falling_objects.add_child(falling_inst)


func _on_delete_border_area_entered(area: Area2D) -> void:
	area.queue_free()


func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/lobby.tscn")


func _on_exit_pressed() -> void:
	get_tree().quit()
