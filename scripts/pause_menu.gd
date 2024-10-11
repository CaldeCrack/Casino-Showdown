extends Control

@onready var player = $"../../../"

func _on_resume_pressed() -> void:
	player.pauseMenu()

func _on_exit_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/menu.tscn")
