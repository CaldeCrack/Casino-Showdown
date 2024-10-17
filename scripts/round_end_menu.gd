extends Control

@onready var button_1 = $VBoxContainer/Button1
@onready var attack_bet: Button = %Attack
@onready var defense_bet: Button = %Defense
@onready var speed_bet: Button = %Speed
@onready var max_health_bet: Button = %MaxHealth

func _ready():
	button_1.pressed.connect(_on_press1)
	attack_bet.pressed.connect(func():_on_bet("ATTACK"))
	defense_bet.pressed.connect(func():_on_bet("DEFENSE"))
	speed_bet.pressed.connect(func():_on_bet("SPEED"))
	max_health_bet.pressed.connect(func():_on_bet("MAX_HEALTH"))


func _on_press1() -> void:
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	#get_tree().change_scene_to_file("res://scenes/main.tscn")
	hide()

func _on_bet(name: String) -> void:
	get_parent().get_parent()._bet(name)


func _end_bet() -> void:
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	hide()
