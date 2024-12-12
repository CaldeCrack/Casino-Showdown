extends Hitbox
class_name SpecialAttackRoulette

var fixed_to: Node3D = null
var direction: Vector3
var orientation: int = 0
var step: float = 0.
var MAX_STEP: int = 10
var multiplier: float = 6.

var cross_product: Vector3


func _ready() -> void:
	cross_product = Vector3.UP.cross(direction)


func _physics_process(delta: float) -> void:
	if fixed_to:
		global_position = fixed_to.global_position
	else:
		position += direction * delta * 15 * 2
	
	if step < MAX_STEP:
		rotation.y = step * orientation * delta
		
		position -= cross_product * orientation * delta * step * multiplier
		step += delta
	else:
		queue_free()
