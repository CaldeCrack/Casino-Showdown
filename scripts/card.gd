extends Node3D

@onready var back: Sprite3D = $Rotate/Back
@onready var front: Sprite3D = $Rotate/Front


var rng: RandomNumberGenerator = RandomNumberGenerator.new()
var suits: Array[String] = ["clubs", "diamonds", "hearts", "spades"]
var ranks: Dictionary = {
	1: "ace",
	2: "02",
	3: "03",
	4: "04",
	5: "05",
	6: "06",
	7: "07",
	8: "08",
	9: "09",
	10: "10",
	11: "jack",
	12: "queen",
	13: "king"
}


func _ready() -> void:
	var back_value: int = rng.randi_range(1, 8)
	var back_face: String = "back0" + str(back_value) + ".png"

	var suit: String = suits.pick_random()
	var rank: int = rng.randi_range(1, 13)
	var rank_value: String = ranks[rank]
	var front_face: String = suit + "_" + rank_value + ".png"

	var path: String = "res://resources/sprites/Cards/"
	var back_path: String = path + back_face
	var front_path: String = path + front_face

	back.texture = load(back_path)
	front.texture = load(front_path)
