class_name Player
extends CharacterBody3D

var WINNER:String = ""
var KILLS: int = 0
var MAX_HEALTH: float = 100
var HEALTH: float = 100
var DEAD: bool = false
var ATTACK: float = 1
var DEFENSE: float = 1
var SPEED: float = 5.0
var direction = Vector3.FORWARD
var paused = false
var SPAWNPOINT: Vector3

const SPRINT_MULT: float = 1.8
const CROUCH_MULT: float = 0.55
const CROUCH_SIZE: float = 0.5
const JUMP_VELOCITY: float = 12.0
const MOUSE_SENSITIVITY: float = 0.002

## globals
@onready var pause_menu: Control = $UI/MarginContainer/PauseMenu
@onready var crosshair: TextureRect = $UI/MarginContainer/Crosshair
@onready var round_timer: Timer = Global.round_timer
@onready var model: Node3D = $"3DGodotRobot"
@onready var godot_anim: AnimationPlayer = $"3DGodotRobot/AnimationPlayer"
@onready var godot_animation_tree: AnimationTree = $"3DGodotRobot/AnimationTree"
@onready var godot_playback: AnimationNodeStateMachinePlayback = godot_animation_tree.get("parameters/playback")
@onready var collision_shape_3d: CollisionShape3D = $"CollisionShape3D"
@onready var spring_arm: SpringArm3D = $SpringArm3D
@onready var ui = $UI
@onready var health_bar: ProgressBar = $UI/MarginContainer/HealthBar
@onready var hp_label = %HPLabel
@onready var atk_label = %ATKLabel
@onready var def_label = %DEFLabel
@onready var spd_label = %SPDLabel
@onready var rounds: Label = %Rounds
@onready var kills: Label = %Kills
@onready var winner: Label = %WINNER
@onready var round_end_menu: Control = $UI/RoundEndMenu
@onready var round_progress_bar: ProgressBar = $UI/RoundProgressBar
@onready var label: Label3D = $Label3D
@onready var hitbox: Hitbox = $"3DGodotRobot/Hitbox"
@onready var special_attack: Node3D = $SpecialAttack


func _ready() -> void:
	winner.hide()
	Global.PLAYER = multiplayer.get_unique_id()
	godot_animation_tree.active = true

	_manual_ui_update()
	round_end_menu.hide()
	round_timer.timeout.connect(_on_round_end)

func _physics_process(delta: float) -> void:
	if is_multiplayer_authority():
		if not is_on_floor():
			velocity += get_gravity() * delta

		_ui_update()
		move_and_slide()
		send_transform.rpc(position, rotation, scale)

	else:
		ui.hide()


func _ui_update() -> void:
	round_progress_bar.value = round_timer.time_left / round_timer.wait_time * 100


func _manual_ui_update() -> void:
	health_bar.max_value = MAX_HEALTH
	HEALTH = MAX_HEALTH
	health_bar.value = HEALTH
	
	hp_label.text = "MAX HP: %.2f" % MAX_HEALTH
	atk_label.text = "ATK: %.2f" % ATTACK
	def_label.text = "DEF: %.2f" % DEFENSE
	spd_label.text = "SPEED: %.2f" % SPEED


func _input(event: InputEvent) -> void:
	if is_multiplayer_authority():
		if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			rotate_y(-event.relative.x * MOUSE_SENSITIVITY)
			spring_arm.rotate_x(-event.relative.y * MOUSE_SENSITIVITY)
			spring_arm.rotation.x = clampf(spring_arm.rotation.x, -deg_to_rad(60), deg_to_rad(90))

		if DEAD:
			return

		_set_movement()

		if event is InputEventMouseButton:
			if event.is_action_pressed("attack"):
				send_animations.rpc("Attack1")


func _set_movement():
	if DEAD:
		return
	var input := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var movement_dir: Vector3 = transform.basis * Vector3(input.x, 0, input.y)
	var speed: float = SPEED

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	if Input.is_action_pressed("crouch"):
		send_animations.rpc("Crouch")
		speed = 0
	elif Input.is_action_pressed("move_back") \
		or Input.is_action_pressed("move_forward") \
		or Input.is_action_pressed("move_left") \
		or Input.is_action_pressed("move_right"):
		if Input.is_action_pressed("sprint"):
			send_animations.rpc("Sprint")
			speed = SPEED * SPRINT_MULT
		else:
			send_animations.rpc("Run")
	else:
		send_animations.rpc("Idle")

	velocity.x = movement_dir.x * speed
	velocity.z = movement_dir.z * speed

	if velocity:
		model.look_at(model.global_position - velocity, Vector3.UP)


func setup(player_data: Statics.PlayerData) -> void:
	name = str(player_data.id)
	set_multiplayer_authority(player_data.id)
	label.text = player_data.name
	SPAWNPOINT = position
	Global.count_players()


@rpc
func send_transform(pos: Vector3, rot: Vector3, size: Vector3) -> void:
	position = lerp(position, pos, 0.5)
	rotation.y = lerp_angle(rotation.y, rot.y, 0.5)
	scale = lerp(scale, size, 0.5)


@rpc("any_peer", "call_local")
func send_animations(anim_name: String) -> void:
	if DEAD:
		godot_playback.travel("ded")
	else:
		godot_playback.travel(anim_name)


func take_damage(damage: float) -> void:
	if is_multiplayer_authority():
		var real_damage : float
		if DEFENSE == 0:
			real_damage = 2 * damage
		else:
			real_damage = damage / DEFENSE

		if real_damage >= HEALTH:
			HEALTH = 0
		else:
			HEALTH -= real_damage
			
		health_bar.value = HEALTH


func _process(_delta):
	if position.y < -4.5:
		DEAD = true
		HEALTH = 0
		health_bar.value = HEALTH
		model.rotation = Vector3(0, 0, 0)
		send_animations.rpc("ded")
	
	if Input.is_action_just_pressed("pause"):
		pauseMenu()
		
	check_alive()


func pauseMenu():
	if paused:
		pause_menu.hide()
		crosshair.show()
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	else:
		crosshair.hide()
		pause_menu.show()
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		
	paused = !paused


func _on_round_end() -> void:
	if is_multiplayer_authority():
		round_end_menu.show()

		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_tree().paused = true

		Global.ROUNDS += 1

		var _max = -1
		for player in Game.players:
			if get_node("/root/Main/%s" % player.id).KILLS > _max:
				_max = get_node("/root/Main/%s" % player.id).KILLS
				WINNER = player.name


func reset_round() -> void:
	DEAD = false
	velocity = Vector3(0,0,0)
	_manual_ui_update()
	round_end_menu.hide()
	position = SPAWNPOINT
	rounds.text = str(Global.ROUNDS)
	look_at(Vector3(-10, 3, 0))
	spring_arm.rotation_degrees = Vector3(-13.3, 0, 0)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	send_animations.rpc("Idle")
	for key in Global.round_rdy.keys():
		Global.round_rdy[key] = false
	Global.count_players()
	round_timer.start()

	get_tree().paused = false


func bet(stat: String) -> void:
	update_stat.rpc(stat)
	if stat == "ATTACK":
		hitbox.update_damage.rpc()
		if special_attack.has_method("update_damage"):
			special_attack.update_damage.rpc()
	_manual_ui_update()


@rpc("call_local")
func update_stat(stat: String) -> void:
	set(stat, Global.slot(get(stat)))


@rpc("any_peer", "call_local", "reliable")
func add_kill() -> void:
	KILLS += 1
	kills.text = "KILLS: %d" % KILLS


@rpc("any_peer", "call_local", "reliable")
func set_rdy(id: int) -> void:
	Global.round_rdy[id] = true
	reset()

func reset() -> void:
	var readies: bool = true
	for value in Global.round_rdy.values():
		readies = readies and value
	
	if readies:
		reset_players.rpc()
		reset_round()
		round_end_menu.reset_bet()


@rpc("authority", "call_remote", "reliable")
func reset_players() -> void:
	get_node("/root/Main/%s" % Global.PLAYER).reset_round()
	get_node("/root/Main/%s" % Global.PLAYER).round_end_menu.reset_bet()

func check_alive() -> void:
	if Global.player_count == 1:
		round_timer.stop()
		_on_round_end()
