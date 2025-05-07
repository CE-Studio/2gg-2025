extends Node2D


func _process(delta: float) -> void:
	var viewport_y = get_viewport_rect().size.y
	position.y = viewport_y * 0.5
