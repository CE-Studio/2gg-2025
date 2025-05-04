class_name Mask
extends Node2D


#region Variables
const FLOAT_CYCLE_SPEED:float = 2.0
const FLOAT_CYCLE_AMPLITUDE:float = 6.0
const EYE_CYCLE_SPEED:float = 0.635

@export var mask_type:Player.Masks = Player.Masks.FOX

var float_cycle:float
var eye_cycle:float
var can_grab:bool = true:
	set(value):
		if can_grab != value:
			modulate.a = 1.0 if value else 0.0
			box.set_deferred(&"disabled", not value)
		can_grab = value
var spawn_particles:PackedScene

@onready var visuals:Node2D = $"Visuals"
@onready var base:Sprite2D = $"Visuals/Base"
@onready var eyes:Sprite2D = $"Visuals/Eyes"
@onready var particles:GPUParticles2D = $"Visuals/Particles"
@onready var box:CollisionShape2D = $"Area2D/CollisionShape2D"
#endregion


func _ready() -> void:
	base.region_rect.position.y = 48 * (mask_type - 1)
	eyes.region_rect.position.y = 48 * (mask_type - 1)
	match mask_type:
		1:
			spawn_particles = preload("res://components/particles/collect_effect_0.tscn")
		2:
			particles.texture = preload("res://assets/textures/particles/star1.svg")
			spawn_particles = preload("res://components/particles/collect_effect_1.tscn")
		3:
			particles.texture = preload("res://assets/textures/particles/star2.svg")
			spawn_particles = preload("res://components/particles/collect_effect_2.tscn")
		4:
			particles.texture = preload("res://assets/textures/particles/star3.svg")
			spawn_particles = preload("res://components/particles/collect_effect_3.tscn")
		5:
			particles.texture = preload("res://assets/textures/particles/star4.svg")
			spawn_particles = preload("res://components/particles/collect_effect_4.tscn")
	float_cycle = randf() * TAU
	eye_cycle = randf() * TAU


func _process(delta: float) -> void:
	visuals.position.y = (sin(float_cycle) * FLOAT_CYCLE_AMPLITUDE)
	float_cycle += FLOAT_CYCLE_SPEED * delta
	var eye_cycle_state = abs(sin(eye_cycle))
	eyes.modulate.a = clampf(randf() * 2.0, (eye_cycle_state * 0.5), eye_cycle_state)
	eye_cycle += EYE_CYCLE_SPEED * delta


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		body.mask_state = mask_type
		var new_spawn_particles = spawn_particles.instantiate()
		get_parent().add_child(new_spawn_particles)
		new_spawn_particles.position = position
