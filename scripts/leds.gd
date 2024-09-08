extends Control

@onready var red_leds: Control = $RedLEDS
@onready var blue_leds: Control = $BlueLEDS


func _on_led_lights_timeout() -> void:
	red_leds.visible = not red_leds.visible
	blue_leds.visible = not blue_leds.visible
