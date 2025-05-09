class_name Trigger
extends Area2D


signal tripped


func _init():
	body_entered.connect(_run)


func _run(body:Node):
	if body is Player:
		tripped.emit()
