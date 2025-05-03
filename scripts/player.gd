class_name Player
extends CharacterBody2D


var SPEED = 600.0
var JUMP_VELOCITY = -810.0
var ACCEL = 6000.0


enum Masks {
	NONE,
	FOX,
	GECKO,
	BEAR,
	CAT,
	BEETLE,
}


signal state_changed


static var has_mask:Array[bool] = [
	true,
	false,
	false,
	false,
	false,
	false,
]


static var instance:Player


@export var mask_state:Masks = Masks.NONE:
	set(value):
		mask_state = value
		_sync_motion()
		state_changed.emit()


func _ready() -> void:
	instance = self
	state_changed.emit()


func _sync_motion() -> void:
	match mask_state:
		Masks.NONE:
			JUMP_VELOCITY = -800.0
			up_direction = Vector2.UP
		Masks.FOX:
			JUMP_VELOCITY = -800.0
			up_direction = Vector2.UP
		Masks.GECKO:
			pass
		Masks.BEAR:
			JUMP_VELOCITY = -800.0
			up_direction = Vector2.UP
		Masks.CAT:
			JUMP_VELOCITY = -800.0
			up_direction = Vector2.UP
		Masks.BEETLE:
			JUMP_VELOCITY = -800.0
			up_direction = Vector2.UP


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta


	if Input.is_action_just_pressed("game_jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY


	var direction := Input.get_axis("game_left", "game_right")
	if direction:
		velocity.x = move_toward(velocity.x, direction * SPEED, ACCEL * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, ACCEL * delta)


	move_and_slide()
