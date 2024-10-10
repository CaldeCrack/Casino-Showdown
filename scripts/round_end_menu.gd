extends Control

@onready var button_1 = $VBoxContainer/Button1

func _ready():
	button_1.pressed.connect(_on_press1)


func _on_press1() -> void:
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	queue_free()
	get_tree().change_scene_to_file("res://scenes/main.tscn")
