@tool
class_name TextWiggle
extends RichTextEffect


var bbcode := "~"


func _process_custom_fx(char_fx: CharFXTransform) -> bool:
	char_fx.offset.y = 2.0 * sin((char_fx.elapsed_time * 5.0) - ((char_fx.transform.origin.x + char_fx.transform.origin.y) * 0.1))
	return true
