class_name Hurtbox
extends Area3D

@export var OWNER: Node3D

func _ready() -> void:
	area_entered.connect(_on_area_entered)


func _on_area_entered(area: Area3D) -> void:
	var hitbox = area as Hitbox
	
	if not OWNER.DEAD and hitbox:
		if OWNER.has_method("take_damage"):
			OWNER.take_damage(hitbox.damage)
			hitbox.damage_dealt.emit()
			
			if OWNER.HEALTH <= 0:
				OWNER.DEAD = true
				update_killed_players.rpc()
				var pp = hitbox.get_parent().get_parent()
				pp.add_kill.rpc()
				OWNER.send_animations.rpc("ded")

@rpc("authority", "call_local", "reliable")
func update_killed_players() -> void:
	Global.player_count -= 1
