extends CharacterBody3D

const MAX_HEALTH: float = 100
var HEALTH: float = 100

const SPEED: float = 5.0
const SPRINT_MULT: float = 1.8
const CROUCH_MULT: float = 0.55
const CROUCH_SIZE: float = 0.5
const JUMP_VELOCITY: float = 12.0
const MOUSE_SENSITIVITY: float = 0.002
var direction = Vector3.FORWARD

#preloads

@onready var round_end_menu = preload("res://scenes/ui/round_end_menu.tscn")



## globals
@onready var round_timer: Timer = Global.round_timer

@onready var model: Node3D = $"3DGodotRobot"
@onready var godot_anim: AnimationPlayer = $"3DGodotRobot/AnimationPlayer"
@onready var godot_animation_tree: AnimationTree = $"3DGodotRobot/AnimationTree"
@onready var godot_playback: AnimationNodeStateMachinePlayback = godot_animation_tree.get("parameters/playback")

@onready var collision_shape_3d: CollisionShape3D = $"CollisionShape3D"
@onready var spring_arm: SpringArm3D = $SpringArm3D

@onready var ui = $UI
@onready var health_bar: ProgressBar = $UI/MarginContainer/HealthBar
@onready var round_progress_bar = $UI/RoundProgressBar
@onready var label: Label3D = $Label3D


func _ready() -> void:
	godot_animation_tree.active = true

	health_bar.value = HEALTH
	health_bar.max_value = MAX_HEALTH
	
	#signals
	round_timer.timeout.connect(_on_round_end)


func _physics_process(delta: float) -> void:
	if is_multiplayer_authority():
		if not is_on_floor():
			velocity += get_gravity() * delta

		_ui_update()

		move_and_slide()
		send_transform.rpc(position, rotation, scale)

	else:
		health_bar.hide()
		
func _ui_update() -> void:
	round_progress_bar.value = round_timer.time_left / round_timer.wait_time * 100

func _input(event: InputEvent) -> void:
	if is_multiplayer_authority():
		if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			rotate_y(-event.relative.x * MOUSE_SENSITIVITY)
			spring_arm.rotate_x(-event.relative.y * MOUSE_SENSITIVITY)
			spring_arm.rotation.x = clampf(spring_arm.rotation.x, -deg_to_rad(40), deg_to_rad(40))

		_set_movement()

		if event is InputEventMouseButton:
			if event.is_action_pressed("attack"):
				send_animations.rpc("Attack1")


func _set_movement():
	var input := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var movement_dir: Vector3 = transform.basis * Vector3(input.x, 0, input.y)
	var speed: float = SPEED

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	if Input.is_action_pressed("crouch"):
		send_animations.rpc("Crouch")
		speed = 0
	elif Input.is_action_pressed("sprint"):
		send_animations.rpc("Sprint")
		speed = SPEED * SPRINT_MULT
	elif Input.is_action_pressed("move_back") \
		or Input.is_action_pressed("move_forward") \
		or Input.is_action_pressed("move_left") \
		or Input.is_action_pressed("move_right"):
		send_animations.rpc("Run")
	else:
		send_animations.rpc("Idle")

	velocity.x = movement_dir.x * speed
	velocity.z = movement_dir.z * speed

	# Debug.log(model.transform.basis.z)
	#model.rotation.y = lerp_angle(
		#model.rotation.y,
		#atan2((model.global_position - velocity).x, (model.global_position - velocity).z),
		#0.5)
	if velocity:
		model.look_at(model.global_position - velocity, Vector3.UP)


func setup(player_data: Statics.PlayerData) -> void:
	name = str(player_data.id)
	set_multiplayer_authority(player_data.id)
	label.text = player_data.name


@rpc
func send_transform(pos: Vector3, rot: Vector3, size: Vector3) -> void:
	position = lerp(position, pos, 0.5)
	rotation.y = lerp_angle(rotation.y, rot.y, 0.5)
	scale = lerp(scale, size, 0.5)


@rpc("call_local")
func send_animations(anim_name: String) -> void:
	godot_playback.travel(anim_name)


func take_damage(damage: float) -> void:
	if is_multiplayer_authority():
		health_bar.value = HEALTH
		HEALTH -= damage


func _on_round_end() -> void:
	ui.add_child(round_end_menu.instantiate())
	
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().paused = true
