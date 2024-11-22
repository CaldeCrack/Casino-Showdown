class_name Hurtbox
extends Area3D

@onready var OWNER = get_parent().get_parent()

func _ready() -> void:
	area_entered.connect(_on_area_entered)


func _on_area_entered(area: Area3D) -> void:
	var hitbox = area as Hitbox
	
	if not OWNER.DEAD and hitbox:
		var pp = hitbox.get_parent().get_parent()
		if OWNER.has_method("take_damage") and pp != OWNER:
			OWNER.take_damage(hitbox.damage)
			hitbox.damage_dealt.emit()
			
			if OWNER.HEALTH <= 0:
				OWNER.DEAD = true
				update_killed_players.rpc()
				pp.add_kill.rpc()
				OWNER.send_animations.rpc("ded")

@rpc("authority", "call_local", "reliable")
func update_killed_players() -> void:
	Global.player_count -= 1
