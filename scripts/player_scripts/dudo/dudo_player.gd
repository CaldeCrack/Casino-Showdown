extends Player

@onready var DICE = preload("res://scenes/objects/dice.tscn")
@onready var marker_3d: Marker3D = $SpecialAttack/Marker3D

@onready var marker_3d_ultimate: Marker3D = $Ultimate/Marker3DUltimate
@onready var marker_3d_ultimate_2: Marker3D = $Ultimate/Marker3DUltimate2
@onready var marker_3d_ultimate_3: Marker3D = $Ultimate/Marker3DUltimate3
@onready var marker_3d_ultimate_4: Marker3D = $Ultimate/Marker3DUltimate4
@onready var marker_3d_ultimate_5: Marker3D = $Ultimate/Marker3DUltimate5

const GRAVITY: float = 9.8
const REBOUND_FACTOR: float = 0.6  # Qué tanto rebota el dado (0 a 1)

# Lista de todos los Marker3D de la habilidad ultimate
var markers = [
	marker_3d_ultimate,
	marker_3d_ultimate_2,
	marker_3d_ultimate_3,
	marker_3d_ultimate_4,
	marker_3d_ultimate_5
]

func _input(event: InputEvent) -> void:
	if is_multiplayer_authority():
		super._input(event)
		
		if Input.is_action_just_pressed("special_attack"):
			_special_attack.rpc()
		
		if Input.is_action_just_pressed("ultimate"):
			_ultimate_attack.rpc()

func _process(delta: float) -> void:
	if marker_3d and is_instance_valid(marker_3d):
		marker_3d.rotation = rotation
		
	for marker in markers:
		if marker and is_instance_valid(marker):
			marker.rotation = rotation

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

	var dice_instance = DICE.instantiate()  # Instancia el dado
	if not dice_instance:
		print("No se pudo instanciar el dado")
		return

	get_parent().add_child(dice_instance)  # Añade el dado a la escena
	dice_instance.global_transform = marker_3d.global_transform  # Coloca el dado en la posición del Marker3D

	# Calcula la dirección inicial
	var initial_direction = -marker_3d.transform.basis.z.normalized()
	var initial_velocity = initial_direction * 20.0  # Velocidad inicial (ajusta el valor según lo que quieras)

	# Pasa la velocidad inicial al dado
	if dice_instance.has_method("launch"):
		dice_instance.launch(initial_velocity)
		

@rpc("any_peer", "call_local")
func _ultimate_attack() -> void:
	# Itera por cada Marker3D y lanza un dado desde su posición
	for marker in markers:
		if not is_instance_valid(marker):
			print("Un Marker3D no es válido, saltando...")
			continue

		var dice_instance = DICE.instantiate()  # Instancia el dado
		if not dice_instance:
			print("No se pudo instanciar el dado para el Marker: ", marker.name)
			continue

		get_parent().add_child(dice_instance)  # Añade el dado a la escena
		dice_instance.global_transform = marker.global_transform  # Coloca el dado en la posición del Marker3D

		# Calcula la dirección inicial del dado basado en el Marker3D
		var initial_direction = -marker.transform.basis.z.normalized()
		var initial_velocity = initial_direction * 20.0  # Velocidad inicial (ajusta según lo que quieras)

		# Pasa la velocidad inicial al dado
		if dice_instance.has_method("launch"):
			dice_instance.launch(initial_velocity)

	
