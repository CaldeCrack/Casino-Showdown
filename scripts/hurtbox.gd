class_name Hurtbox
extends Area3D


func _ready() -> void:
	area_entered.connect(_on_area_entered)


func _on_area_entered(area: Area3D) -> void:
	var hitbox = area as Hitbox
	
	if hitbox:
		if owner.has_method("take_damage"):
			owner.take_damage(hitbox.damage)
			hitbox.damage_dealt.emit()