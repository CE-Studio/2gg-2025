extends Camera2D


var tracking:Node2D
var tracking_pos := Vector2.ZERO
var tracking_obj := false
var speed := 10.0


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS


func _process(delta: float) -> void:
	if tracking_obj:
		if is_instance_valid(tracking):
			tracking_pos = Vector2(tracking.global_position)
	global_position = global_position.lerp(tracking_pos, delta * speed)


func get_mouse_pos() -> Vector2:
	var vp := get_viewport()
	var rect := vp.get_visible_rect().size / 2.0
	var pos := vp.get_mouse_position() - rect
	return pos + global_position
