class_name Respawner
extends Marker2D


@export var template:PackedScene
@export var existing:Node2D


func respawn() -> void:
	if is_instance_valid(existing):
		existing.queue_free()
	var new:Node2D = template.instantiate()
	get_parent().add_child.call_deferred(new)
	new.global_position = global_position
	existing = new
