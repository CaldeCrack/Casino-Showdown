extends RichTextLabel


@export var url: String


func _ready() -> void:
	text = "[url=%s]%s[/url]" % [url, url]
