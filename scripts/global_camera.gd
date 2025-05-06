extends Camera2D


var tracking:Node2D
var tracking_pos := Vector2.ZERO
var tracking_obj := false
var speed := 10.0
var bounds:Area2D


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS


func _process(delta: float) -> void:
	if tracking_obj:
		if is_instance_valid(tracking):
			tracking_pos = Vector2(tracking.global_position)
	global_position = global_position.lerp(tracking_pos, delta * speed)
	if bounds != null:
		var bound_coords = bounds.get_coord_bounds()
		global_position.x = clampf(global_position.x, bound_coords[0], bound_coords[1])
		global_position.y = clampf(global_position.y, bound_coords[2], bound_coords[3])


func get_mouse_pos() -> Vector2:
	var vp := get_viewport()
	var rect := vp.get_visible_rect().size / 2.0
	var pos := vp.get_mouse_position() - rect
	return pos + global_position
