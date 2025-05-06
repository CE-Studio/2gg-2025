class_name Breakable
extends RigidBody2D


func destroy() -> void:
	queue_free()
