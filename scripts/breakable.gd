class_name Breakable
extends StaticBody2D


func destroy() -> void:
	queue_free()
