@tool
class_name TextJitter
extends RichTextEffect


var bbcode := "j"


func _process_custom_fx(char_fx: CharFXTransform) -> bool:
	char_fx.offset.y = randf_range(-2, 2)
	char_fx.offset.x = randf_range(-2, 2)
	return true
