extends Control

@onready var button_1 = $VBoxContainer/Button1
@onready var attack_bet: Button = %Attack
@onready var defense_bet: Button = %Defense
@onready var speed_bet: Button = %Speed
@onready var max_health_bet: Button = %MaxHealth

@onready var player = get_parent().get_parent()

var BET: String = ""

func _ready():
	button_1.pressed.connect(_on_press1)
	attack_bet.pressed.connect(func():_on_bet("ATTACK"))
	defense_bet.pressed.connect(func():_on_bet("DEFENSE"))
	speed_bet.pressed.connect(func():_on_bet("SPEED"))
	max_health_bet.pressed.connect(func():_on_bet("MAX_HEALTH"))
	
	Global.round_timer.timeout.connect(func(): Global.round_end_timer.start())
	
	Global.round_end_timer.timeout.connect(func():
		if BET:
			player.bet(BET)
		else:
			player.bet("MAX_HEALTH")
		
		BET=""
		attack_bet.disabled = false
		defense_bet.disabled = false
		speed_bet.disabled = false
		max_health_bet.disabled = false)



func _on_press1() -> void:
	player._set_rdy.rpc_id(1, multiplayer.get_unique_id())


func _on_bet(name: String) -> void:
	match name:
		"ATTACK":
			defense_bet.disabled = true
			speed_bet.disabled = true
			max_health_bet.disabled = true
		"DEFENSE":
			attack_bet.disabled = true
			speed_bet.disabled = true
			max_health_bet.disabled = true
		"SPEED":
			attack_bet.disabled = true
			defense_bet.disabled = true
			max_health_bet.disabled = true
		"MAX_HEALTH":
			attack_bet.disabled = true
			defense_bet.disabled = true
			speed_bet.disabled = true
	
	BET = name


func _end_bet() -> void:
	get_tree().paused = false
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	Global.round_rdy = {}
