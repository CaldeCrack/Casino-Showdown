extends Control


var falling := load("res://autoloads/falling_objects.tscn")
var fallingInst = falling.instantiate()

func _ready() -> void:
	add_child(fallingInst)


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/menu.tscn")


func _on_rich_text_label_meta_clicked(meta: Variant) -> void:
	OS.shell_open(str(meta))
