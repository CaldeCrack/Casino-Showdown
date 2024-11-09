extends Control

@onready var attack_bet: Button = %Attack
@onready var defense_bet: Button = %Defense
@onready var speed_bet: Button = %Speed
@onready var max_health_bet: Button = %MaxHealth
@onready var player = get_parent().get_parent()
@onready var ready_button: Button = $VBoxContainer/Ready


var round_timer: Timer = Global.round_timer
var round_rdy = Global.round_rdy
var BET: String = ""

func _ready():
	attack_bet.pressed.connect(func():_on_bet("ATTACK"))
	defense_bet.pressed.connect(func():_on_bet("DEFENSE"))
	speed_bet.pressed.connect(func():_on_bet("SPEED"))
	max_health_bet.pressed.connect(func():_on_bet("MAX_HEALTH"))
	ready_button.pressed.connect(_end_bet.rpc)


func _process(_delta: float) -> void:
	if Global.ROUNDS > 2:
		player.winner.show()
		player.winner.text += player.WINNER
		queue_free()


func _on_bet(_name: String) -> void:
	match _name:
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
	
	BET = _name
	ready_button.disabled = false


@rpc("any_peer")
func _end_bet() -> void:
	player.set_rdy.rpc(multiplayer.get_unique_id())


func reset_bet() -> void:
	if BET: player.bet(BET)
	else: player.bet("MAX_HEALTH")
	
	BET = ""
	attack_bet.disabled = false
	defense_bet.disabled = false
	speed_bet.disabled = false
	max_health_bet.disabled = false
