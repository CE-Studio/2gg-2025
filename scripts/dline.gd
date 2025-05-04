class_name DiaLine
extends Node


@export var focus:Node2D
@export var char:int = 0
@export var lines:Array[String] = []


signal done


func _finish() -> void:
	GlobalCamera.tracking = Player.instance
	done.emit()


func run() -> void:
	if is_instance_valid(focus):
		GlobalCamera.tracking = focus
	TextBox.done.connect(_finish, CONNECT_ONE_SHOT)
	TextBox.speak(char, lines)
