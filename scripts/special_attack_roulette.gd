extends Hitbox
class_name SpecialAttackRoulette

var direction: Vector3
var orientation: int = 0
var step: float = 0.
var multiplier: float = 6.

var cross_product: Vector3


func _ready() -> void:
	cross_product = Vector3.UP.cross(direction)


func _physics_process(delta: float) -> void:
	position += direction * delta * 15 * 2
	
	if step < 15:
		rotation.y = step * orientation * delta
		
		position -= cross_product * orientation * delta * step * multiplier
		step += delta
	else:
		queue_free()
