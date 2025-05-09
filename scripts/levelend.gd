extends Area2D


@export_file("*.tscn") var scene:String = ""


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		assert(scene != "")
		get_tree().change_scene_to_file.call_deferred(scene)
