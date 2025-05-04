class_name Player
extends CharacterBody2D


var SPEED := 600.0
var JUMP_VELOCITY := -810.0
var ACCEL := 6000.0
var AIR_MOD := 0.3


enum Masks {
	NONE,
	FOX,
	GECKO,
	BEAR,
	CAT,
	BEETLE,
}


signal state_changed(mask_id)


static var has_mask:Array[bool] = [
	true,
	false,
	false,
	false,
	false,
	false,
]


static var instance:Player
static var spawnpoint := Vector2.ZERO


var jumped := false
var spent := false


@export var mask_state:Masks = Masks.NONE:
	set(value):
		mask_state = value
		if is_instance_valid(pointer):
			_sync_motion()
		else:
			_sync_motion.call_deferred()
		state_changed.emit(value)


@onready var pointer:Sprite2D = $pointer


func _ready() -> void:
	spawnpoint = Vector2(global_position)
	instance = self
	state_changed.emit()
	GlobalCamera.tracking = self
	GlobalCamera.tracking_obj = true
	_sync_motion()


func _sync_motion() -> void:
	match mask_state:
		Masks.NONE:
			up_direction = Vector2.UP
			pointer.hide()
		Masks.FOX:
			up_direction = Vector2.UP
			pointer.show()
		Masks.GECKO:
			pointer.hide()
		Masks.BEAR:
			up_direction = Vector2.UP
			pointer.show()
		Masks.CAT:
			up_direction = Vector2.UP
			pointer.hide()
		Masks.BEETLE:
			up_direction = Vector2.UP
			pointer.show()


func _physics_process(delta:float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta * Vector2(up_direction.x, up_direction.y * -1)
	else:
		spent = false
		jumped = false
	_movement_and_input(delta)
	move_and_slide()
	if pointer.visible:
		pointer.look_at(GlobalCamera.get_mouse_pos())
	if global_position.y > 10000:
		print("a")
		velocity = Vector2.ZERO
		global_position = spawnpoint


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("game_debug"):
		$"../testlines/l1".run()


func _movement_and_input(delta:float) -> void:
	if not GameState.is_accepting_input():
		if is_on_floor():
			velocity.x = move_toward(velocity.x, 0, ACCEL * delta)
		return
	if Input.is_action_just_pressed("game_jump") and not jumped:
		velocity.y = -JUMP_VELOCITY * up_direction.y
		jumped = true
	var direction := Input.get_axis("game_left", "game_right")
	if direction:
		if is_on_floor():
			velocity.x = move_toward(velocity.x, direction * SPEED, ACCEL * delta)
		else:
			velocity.x = move_toward(velocity.x, direction * SPEED, ACCEL * delta * AIR_MOD)
	else:
		if is_on_floor():
			velocity.x = move_toward(velocity.x, 0, ACCEL * delta)
	_masks(delta)


func _masks(delta:float) -> void:
	var dir := Vector2.UP
	var trigger := false
	if Input.is_action_just_pressed("game_action_mouse"):
		trigger = true
		dir = pointer.transform.basis_xform(Vector2.RIGHT).normalized()
	if trigger:
		match mask_state:
			Masks.NONE:
				pass
			Masks.FOX:
				if not spent:
					velocity = dir * 1010
					spent = true
			Masks.GECKO:
				if not spent:
					up_direction.y *= -1
					spent = true
			Masks.BEAR:
				pass
			Masks.CAT:
				pass
			Masks.BEETLE:
				if is_on_wall() and not spent:
					velocity = dir * 1010
					spent = true
	if mask_state == Masks.BEETLE:
		if Input.is_action_pressed("game_jump"):
			if is_on_wall():
				velocity.y = clampf(velocity.y, -absf(velocity.y), 0)
			else:
				velocity.y = clampf(velocity.y, -absf(velocity.y), 100)
