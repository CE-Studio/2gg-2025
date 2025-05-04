class_name Mask
extends Node2D


#region Variables
const FLOAT_CYCLE_SPEED:float = 2.0
const FLOAT_CYCLE_AMPLITUDE:float = 6.0
const EYE_CYCLE_SPEED:float = 0.635

@export_enum("None", "Fox", "Gecko", "Bear", "Cat", "Beetle") var mask_type = 1

var float_cycle:float
var eye_cycle:float
var can_grab:bool = true:
	set(value):
		if can_grab != value:
			modulate.a = 1.0 if value else 0.0
			box.disabled = not value
		can_grab = value

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
		2: particles.texture = load("res://assets/textures/particles/star1.svg")
		3: particles.texture = load("res://assets/textures/particles/star2.svg")
		4: particles.texture = load("res://assets/textures/particles/star3.svg")
		5: particles.texture = load("res://assets/textures/particles/star4.svg")
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
