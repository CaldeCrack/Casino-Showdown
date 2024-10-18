class_name Hurtbox
extends Area3D

@export var OWNER: Node3D

func _ready() -> void:
	area_entered.connect(_on_area_entered)


func _on_area_entered(area: Area3D) -> void:
	var hitbox = area as Hitbox
	
	if hitbox:
		if OWNER.has_method("take_damage"):
			OWNER.take_damage(hitbox.damage)
			hitbox.damage_dealt.emit()
			
			if OWNER.HEALTH <= 0:
				var pp = get_parent().get_parent()
				pp.KILLS += 1
				pp.kills.text = "KILLS: %d" % OWNER.KILLS
				
				print(pp.KILLS," | " , multiplayer.get_unique_id())
				
				#Global.round_timer.stop()
