extends Camera2D


var tracking:Node2D
var tracking_pos := Vector2.ZERO
var tracking_obj := false
var speed := 1.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if tracking_obj:
		if is_instance_valid(tracking):
			tracking_pos = Vector2(tracking.global_position)
	global_position = global_position.lerp(tracking_pos, delta * speed)
