class_name Door
extends Node2D


@onready var anim:AnimationPlayer = $AnimationPlayer


func operate(open:bool) -> void:
	if open:
		anim.play("open")
	else:
		anim.play_backwards("open")
