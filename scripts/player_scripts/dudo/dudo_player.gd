extends Player

@onready var DICE = preload("res://scenes/objects/dice.tscn")
@onready var marker_3d: Marker3D = $SpecialAttack/Marker3D

@onready var marker_3d_ultimate: Marker3D = $Ultimate/Marker3DUltimate
@onready var marker_3d_ultimate_2: Marker3D = $Ultimate/Marker3DUltimate2
@onready var marker_3d_ultimate_3: Marker3D = $Ultimate/Marker3DUltimate3
@onready var marker_3d_ultimate_4: Marker3D = $Ultimate/Marker3DUltimate4
@onready var marker_3d_ultimate_5: Marker3D = $Ultimate/Marker3DUltimate5

@onready var dice_recharge: Timer = $dice_recharge
@onready var cd_ultimate: Timer = $cd_ultimate


const GRAVITY: float = 9.8
const REBOUND_FACTOR: float = 0.6  # Qué tanto rebota el dado (0 a 1)

var dice_count: int = 5
var available_ult: bool = true

func _input(event: InputEvent) -> void:
	if is_multiplayer_authority():
		super._input(event)
		
		if Input.is_action_just_pressed("special_attack"):
			_special_attack.rpc()
			if dice_recharge.is_stopped():
				dice_recharge.start()
		
		if available_ult:
			if Input.is_action_just_pressed("ultimate"):
				available_ult = false
				_ultimate_attack.rpc()
				if cd_ultimate.is_stopped():
					cd_ultimate.start()

func _process(delta: float) -> void:
	super._process(delta)
	if marker_3d and is_instance_valid(marker_3d):
		marker_3d.rotation = rotation


func init_marker() -> void:
	marker_3d = $SpecialAttack/Marker3D
	if is_instance_valid(marker_3d):
		print("Marker3D inicializado correctamente.")
	else:
		print("Error: Marker3D no válido.")

@rpc("any_peer", "call_local")
func _special_attack() -> void:
	if not is_instance_valid(marker_3d):
		print("Marker3D no es válido")
		return

	if dice_count > 0:
		var dice_instance = DICE.instantiate()  # Instancia el dado
		if not dice_instance:
			print("No se pudo instanciar el dado")
			return

		dice_instance.global_transform = marker_3d.global_transform  # Coloca el dado en la posición del Marker3D

		# Disminuimos el contador
		if dice_count > 0:
			dice_count -= 1

		# Calcula la dirección inicial
		var initial_direction = -marker_3d.transform.basis.z.normalized()
		var initial_velocity = initial_direction * 20.0  # Velocidad inicial (ajusta el valor según lo que quieras)

		# Pasa la velocidad inicial al dado
		if dice_instance.has_method("launch"):
			dice_instance.launch(initial_velocity)

		add_child(dice_instance)  # Añade el dado a la escena


@rpc("any_peer", "call_local")
func _ultimate_attack() -> void:
	var markers = [
		marker_3d_ultimate,
		marker_3d_ultimate_2,
		marker_3d_ultimate_3,
		marker_3d_ultimate_4,
		marker_3d_ultimate_5
	]

	# Itera por cada Marker3D y lanza un dado desde su posición
	for marker in markers:
		if not is_instance_valid(marker):
			print("Un Marker3D no es válido, saltando...")
			continue

		# Instanciar el dado
		var dice_instance = DICE.instantiate()
		if not dice_instance:
			print("No se pudo instanciar el dado para el Marker: ", marker.name)
			continue

		# Agregar el dado a la escena y configurarlo en la posición global del marcador
		dice_instance.global_transform = marker.global_transform

		# La dirección inicial del dado está basada en el eje -Z del marcador
		var initial_direction = -marker.global_transform.basis.z.normalized()
		var initial_velocity = initial_direction * 20.0  # Ajusta la velocidad según lo que desees

		# Lanza el dado con la velocidad calculada
		if dice_instance.has_method("launch"):
			dice_instance.launch(initial_velocity)

		add_child(dice_instance)

@rpc("any_peer", "call_local")
func plusone() -> void:
	dice_count += 1

func _on_dice_recharge_timeout() -> void:
	if dice_count < 5:
		plusone.rpc()
	else:
		dice_recharge.stop()


func _on_cd_ultimate_timeout() -> void:
	available_ult = true
	cd_ultimate.stop()

@rpc("any_peer", "call_local", "reliable")
func reset_skills() -> void:
	dice_count = 5
	available_ult = true
	dice_recharge.stop()
	cd_ultimate.stop()

func reset_round() -> void:
	super.reset_round()
	for children in get_children():
		if children.get_class() == 'RigidBody3D':
			children.queue_free()
