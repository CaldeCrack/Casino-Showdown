extends Control

@onready var button_1 = $VBoxContainer/Button1
@onready var attack_bet: Button = $VBoxContainer/Attack
@onready var defense_bet: Button = $VBoxContainer/Defense
@onready var evasion_bet: Button = $VBoxContainer/Evasion
@onready var accuracy_bet: Button = $VBoxContainer/Accuracy
@onready var max_health_bet: Button = $VBoxContainer/MaxHealth

func _ready():
	button_1.pressed.connect(_on_press1)
	attack_bet.pressed.connect(_on_pressed_attack)
	defense_bet.pressed.connect(_on_pressed_defense)
	evasion_bet.pressed.connect(_on_pressed_evasion)
	accuracy_bet.pressed.connect(_on_pressed_accuracy)
	max_health_bet.pressed.connect(_on_pressed_max_health)


func _on_press1() -> void:
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	queue_free()
	get_tree().change_scene_to_file("res://scenes/main.tscn")

func _on_pressed_attack() -> void:
	get_parent().get_parent()._bet_on_attack()

func _on_pressed_defense() -> void:
	get_parent().get_parent()._bet_on_defense()

func _on_pressed_evasion() -> void:
	get_parent().get_parent()._bet_on_evasion()

func _on_pressed_accuracy() -> void:
	get_parent().get_parent()._bet_on_accuracy()

func _on_pressed_max_health() -> void:
	get_parent().get_parent()._bet_on_max_health()
