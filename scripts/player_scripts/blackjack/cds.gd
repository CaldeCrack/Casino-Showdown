extends HBoxContainer


@onready var cd: Timer = $"../../../SpecialAttack/CD"
@onready var special_attack: TextureProgressBar = $Container1/SpecialAttack


func _ready() -> void:
	special_attack.max_value = cd.wait_time


func _process(_delta: float) -> void:
	special_attack.value = cd.wait_time - cd.time_left
