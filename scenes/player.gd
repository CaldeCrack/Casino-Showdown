extends CharacterBody3D


const SPEED: float = 5.0
const JUMP_VELOCITY: float = 12.0
const MOUSE_SENSITIVITY: float = 0.002


func get_input():
	var input = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var movement_dir = transform.basis * Vector3(input.x, 0, input.y)
	velocity.x = movement_dir.x * SPEED
	velocity.z = movement_dir.z * SPEED

func _physics_process(delta: float) -> void:
	if is_multiplayer_authority():
		# Gravity.
		if not is_on_floor():
			velocity += get_gravity() * delta

		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY

		get_input()
		move_and_slide()

func _input(event):
	if is_multiplayer_authority() and event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * MOUSE_SENSITIVITY)
		$Camera3D.rotate_x(-event.relative.y * MOUSE_SENSITIVITY)
		$Camera3D.rotation.x = clampf($Camera3D.rotation.x, -deg_to_rad(90), deg_to_rad(90))

func setup(player_data: Statics.PlayerData) -> void:
	name = str(player_data.id)
	set_multiplayer_authority(player_data.id)
