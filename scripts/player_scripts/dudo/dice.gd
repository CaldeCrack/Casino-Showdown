extends RigidBody3D

const GRAVITY: float = 18
const REBOUND_FACTOR: float = 0.9  # Qué tanto rebota el dado (0 a 1)
const MIN_VELOCITY: float = 0.1  # Velocidad mínima para detener el rebote
const ROTATION_SPEED: float = 5.0  # Velocidad de rotación del dado

var velocity: Vector3
var bounces: int = 4  # Número de rebotes permitidos



func _ready() -> void:
	# Configura las propiedades físicas del dado
	gravity_scale = 0  # Usamos nuestra propia gravedad
	angular_velocity = Vector3(
		randf_range(-ROTATION_SPEED, ROTATION_SPEED),
		randf_range(-ROTATION_SPEED, ROTATION_SPEED),
		randf_range(-ROTATION_SPEED, ROTATION_SPEED)
	)

func launch(initial_velocity: Vector3) -> void:
	velocity = initial_velocity

func _physics_process(delta: float) -> void:
	# Aplica la gravedad
	velocity.y -= GRAVITY * delta
	
	# Mueve el dado manualmente
	var motion = velocity * delta
	var collision = move_and_collide(motion)
	
	# Rota el dado
	rotate_x(angular_velocity.x * delta)
	rotate_y(angular_velocity.y * delta)
	rotate_z(angular_velocity.z * delta)
	
	if collision != null:
		# Reduce el número de rebotes permitidos
		bounces -= 1
		
		# Aplica el rebote si quedan rebotes disponibles
		if bounces > 0:
			# Calcula la nueva velocidad después del rebote
			velocity = velocity.bounce(collision.get_normal()) * REBOUND_FACTOR
			
			# Si la velocidad es muy baja, detén el movimiento
			if velocity.length() < MIN_VELOCITY:
				velocity = Vector3.ZERO
				bounces = 0  # Detén los rebotes completamente
		else:
			# Detén el movimiento si no quedan rebotes
			velocity = Vector3.ZERO
	
	# Borra el dado si ya no hay velocidad y no quedan rebotes
	if bounces <= 0 and velocity == Vector3.ZERO:
		queue_free()  # Elimina este nodo del árbol de la escena
