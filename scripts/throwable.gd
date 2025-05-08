class_name Throwable
extends RigidBody2D


@export var break_on_impact := false


func _init() -> void:
	body_entered.connect(_on_body_entered)
	can_sleep = false


func  _on_body_entered(body:Node) -> void:
	pass


func _physics_process(delta: float) -> void:
	if is_instance_valid(Player.instance):
		gravity_scale = Player.instance.obj_grav_dir
