class_name Throwable
extends RigidBody2D


@export var break_on_impact := false
var pv := Vector2.ZERO


func _init() -> void:
	body_entered.connect(_on_body_entered)
	can_sleep = false
	contact_monitor = true
	max_contacts_reported = 1


func  _on_body_entered(body:Node) -> void:
	if break_on_impact:
		var h = pv.abs()
		h = maxf(h.x, h.y)
		if h > 1500:
			queue_free()


func _physics_process(delta: float) -> void:
	pv = Vector2(linear_velocity)
	if is_instance_valid(Player.instance):
		gravity_scale = Player.instance.obj_grav_dir
