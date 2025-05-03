extends Node2D


#region Variables
const FLOAT_CYCLE_SPEED:float = 2.0
const FLOAT_CYCLE_AMPLITUDE:float = 6.0
const EYE_CYCLE_SPEED:float = 0.635

@export_enum("Fox", "Gecko", "Bear", "Cat", "Beetle") var mask_type = 0

var origin:Vector2
var float_cycle:float
var eye_cycle:float

@onready var visuals:Node2D = $"Visuals"
@onready var base:Sprite2D = $"Visuals/Base"
@onready var eyes:Sprite2D = $"Visuals/Eyes"
@onready var particles:GPUParticles2D = $"Visuals/Particles"
#endregion


func _ready() -> void:
	origin = position
	base.region_rect.position.y = 48 * mask_type
	eyes.region_rect.position.y = 48 * mask_type
	match mask_type:
		1: particles.texture = load("res://assets/textures/particles/star1.svg")
		2: particles.texture = load("res://assets/textures/particles/star2.svg")
		3: particles.texture = load("res://assets/textures/particles/star3.svg")
		4: particles.texture = load("res://assets/textures/particles/star4.svg")


func _process(delta: float) -> void:
	visuals.position.y = position.y + (sin(float_cycle) * FLOAT_CYCLE_AMPLITUDE)
	float_cycle += FLOAT_CYCLE_SPEED * delta
	var eye_cycle_state = abs(sin(eye_cycle))
	eyes.modulate.a = clampf(randf() * 2.0, (eye_cycle_state * 0.5), eye_cycle_state)
	eye_cycle += EYE_CYCLE_SPEED * delta
