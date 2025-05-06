extends Area2D


@onready var box:CollisionShape2D = $"CollisionShape2D"


func _ready() -> void:
	GlobalCamera.bounds = self


func get_coord_bounds() -> Array:
	var output = []
	var half_size = Vector2(box.shape.size.x, box.shape.size.y) * 0.5
	output.append(box.position.x - half_size.x)
	output.append(box.position.x + half_size.x)
	output.append(box.position.y - half_size.y)
	output.append(box.position.y + half_size.y)
	return output
