class_name Airplane
extends Node2D


@export var canmove := true
@export var facing := true
@export var targpos := Vector2.ZERO
@export var can_pickup := false
@export var holding := false
@export var holdpos := Vector2.ZERO


func _process(delta: float) -> void:
	
	if canmove and (not holding) and (targpos != global_position):
		if targpos.x < global_position.x:
			facing = false
		elif targpos.x > global_position.x:
			facing = true
		global_position = global_position.move_toward(targpos, delta * 400)
	
	if canmove and holding and (holdpos != global_position):
		if holdpos.x < global_position.x:
			facing = false
		elif holdpos.x > global_position.x:
			facing = true
		global_position = global_position.move_toward(holdpos, delta * 400)
	
	if facing:
		scale.x = lerpf(scale.x, 1, delta * 10)
	else:
		scale.x = lerpf(scale.x, -1, delta * 10)


func set_targpos(pos:Vector2) -> void:
	targpos = pos


func set_holdpos(pos:Vector2) -> void:
	holdpos = pos


func _on_area_2d_body_entered(body: Node2D) -> void:
	if can_pickup:
		if body is Throwable:
			body.queue_free()
			holding = true
