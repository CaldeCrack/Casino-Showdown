extends HBoxContainer


@onready var sp_cd: Timer = $"../../../SpecialAttack/CD"
@onready var ult_cd: Timer = $"../../../Ultimate/CD"
@onready var special_attack: TextureProgressBar = $Container1/SpecialAttack
@onready var ultimate: TextureProgressBar = $Container2/Ultimate


func _ready() -> void:
	special_attack.max_value = sp_cd.wait_time
	ultimate.max_value = ult_cd.wait_time


func _process(_delta: float) -> void:
	special_attack.value = sp_cd.wait_time - sp_cd.time_left
	ultimate.value = ult_cd.wait_time - ult_cd.time_left
