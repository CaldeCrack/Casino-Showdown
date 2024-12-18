extends Control


var falling := load("res://autoloads/falling_objects.tscn")
var fallingInst = falling.instantiate()

func _ready() -> void:
	add_child(fallingInst)


func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/lobby.tscn")


func _on_credits_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/credits.tscn")


func _on_exit_pressed() -> void:
	get_tree().quit()
