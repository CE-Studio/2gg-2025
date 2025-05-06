class_name Throwable
extends RigidBody2D


@export var break_on_impact := false


func _init() -> void:
	body_entered.connect(_on_body_entered)


func  _on_body_entered(body:Node) -> void:
	pass
