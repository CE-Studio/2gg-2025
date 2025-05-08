class_name FloorButton
extends StaticBody2D


signal pressed


var count:int = 0
var outp := false


@export var doors:Array[Door] = []
@export var respawners:Array[Respawner] = []
@export var sticky := false
@onready var anim:AnimationPlayer = $AnimationPlayer


func _on_area_2d_body_entered(body: Node2D) -> void:
	count += 1
	if count > 0:
		if not outp:
			anim.play("press")
			outp = true
			for i in doors:
				i.operate(true)
			for i in respawners:
				i.respawn()
			pressed.emit()


func _on_area_2d_body_exited(body: Node2D) -> void:
	if sticky:
		return
	count -= 1
	if count <= 0:
		if outp:
			anim.play_backwards("press")
			outp = false
			for i in doors:
				i.operate(false)
