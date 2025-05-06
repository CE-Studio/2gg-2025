extends Area2D


@export_file("*.tscn") var scene:String = ""


func _on_body_entered(body: Node2D) -> void:
	assert(scene != "")
	if body is Player:
		get_tree().change_scene_to_file.call_deferred(scene)
