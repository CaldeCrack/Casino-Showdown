extends CharacterBody3D


const SPEED: float = 5.0
const SPRINT_MULT: float = 1.5
const CROUCH_MULT: float = 0.55
const CROUCH_SIZE: float = 0.5
const JUMP_VELOCITY: float = 12.0
const MOUSE_SENSITIVITY: float = 0.002

@onready var label := $Label3D
@onready var camera := $Camera3D


func get_speed() -> float:
	var speed: float = SPEED
	if Input.is_action_pressed("sprint"):
		speed = SPEED * SPRINT_MULT
	elif Input.is_action_pressed("crouch"):
		self.scale.y = CROUCH_SIZE
		speed = SPEED * CROUCH_MULT
	elif Input.is_action_just_released("crouch"):
		self.scale.y = 1.0
	return speed


func get_input():
	var input := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var movement_dir: Vector3 = transform.basis * Vector3(input.x, 0, input.y)
	var speed: float = get_speed()
	velocity.x = movement_dir.x * speed
	velocity.z = movement_dir.z * speed


func _physics_process(delta: float) -> void:
	if is_multiplayer_authority():
		if not is_on_floor():
			velocity += get_gravity() * delta

		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY

		get_input()
		move_and_slide()
		send_transform.rpc(position, rotation, scale)


func _input(event):
	if is_multiplayer_authority() and event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * MOUSE_SENSITIVITY)
		camera.rotate_x(-event.relative.y * MOUSE_SENSITIVITY)
		camera.rotation.x = clampf(camera.rotation.x, -deg_to_rad(90), deg_to_rad(90))


func setup(player_data: Statics.PlayerData) -> void:
	name = str(player_data.id)
	set_multiplayer_authority(player_data.id)
	label.text = player_data.name


@rpc
func send_transform(pos: Vector3, rot: Vector3, size: Vector3) -> void:
	position = lerp(position, pos, 0.5)
	rotation.y = lerp_angle(rotation.y, rot.y, 0.5)
	scale = lerp(scale, size, 0.5)
