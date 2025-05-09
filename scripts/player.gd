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
static var was_mouse := true


var jumped := false
var spent := false
var facing := true
var obj_grav_dir := 1.0
var ong := true

var inrange:Node2D:
	set(value):
		inrange = value
		if mask_state == Masks.BEAR:
			if value is Throwable:
				pointer.show()
			else:
				pointer.hide()


@export var mask_state:Masks = Masks.NONE:
	set(value):
		mask_state = value
		if is_instance_valid(pointer):
			_sync_motion()
		else:
			_sync_motion.call_deferred()
		state_changed.emit(value)
		match value:
			Masks.NONE:
				mask_particles.emitting = false
			Masks.FOX:
				mask_particles.emitting = true
				mask_particles.texture = ptcl0
			Masks.GECKO:
				mask_particles.emitting = true
				mask_particles.texture = ptcl1
			Masks.BEAR:
				mask_particles.emitting = true
				mask_particles.texture = ptcl2
			Masks.CAT:
				mask_particles.emitting = true
				mask_particles.texture = ptcl3
			Masks.BEETLE:
				mask_particles.emitting = true
				mask_particles.texture = ptcl4


@onready var pointer:Sprite2D = $pointer
@onready var cata:TileMapLayer = $"../cata"
@onready var catb:TileMapLayer = $"../catb"
@onready var hb:CollisionShape2D = $CollisionShape2D
@onready var bod:Node2D = $body
@onready var mask_particles:GPUParticles2D = $GPUParticles2D

@onready var ptcl0:Texture2D = preload("res://assets/textures/particles/orb0.svg")
@onready var ptcl1:Texture2D = preload("res://assets/textures/particles/orb1.svg")
@onready var ptcl2:Texture2D = preload("res://assets/textures/particles/orb2.svg")
@onready var ptcl3:Texture2D = preload("res://assets/textures/particles/orb3.svg")
@onready var ptcl4:Texture2D = preload("res://assets/textures/particles/orb4.svg")


func _ready() -> void:
	spawnpoint = Vector2(global_position)
	instance = self
	state_changed.emit()
	GlobalCamera.tracking = self
	GlobalCamera.tracking_obj = true
	catb.enabled = false
	mask_particles.emitting = false
	_sync_motion()


func _process(delta: float) -> void:
	bod.scale.y = lerpf(bod.scale.y, up_direction.y * -1, delta * 10)
	if velocity.x > 0:
		facing = true
	if velocity.x < 0:
		facing = false
	if facing:
		bod.scale.x = lerpf(bod.scale.x, 1, delta * 10)
	else:
		bod.scale.x = lerpf(bod.scale.x, -1, delta * 10)


func _sync_motion() -> void:
	match mask_state:
		Masks.NONE:
			up_direction = Vector2.UP
			pointer.hide()
			hb.scale.x = 1
		Masks.FOX:
			up_direction = Vector2.UP
			pointer.show()
			hb.scale.x = 1
		Masks.GECKO:
			pointer.hide()
			hb.scale.x = 1
		Masks.BEAR:
			up_direction = Vector2.UP
			hb.scale.x = 1
			pointer.hide()
		Masks.CAT:
			up_direction = Vector2.UP
			pointer.hide()
			hb.scale.x = 1
		Masks.BEETLE:
			up_direction = Vector2.UP
			pointer.hide()
			hb.scale.x = 1


func _physics_process(delta:float) -> void:
	ong = is_on_floor()
	if not is_on_floor():
		velocity += get_gravity() * delta * Vector2(up_direction.x, up_direction.y * -1)
	else:
		spent = false
		jumped = false
	_movement_and_input(delta)
	move_and_slide()
	if pointer.visible:
		if was_mouse:
			pointer.look_at(GlobalCamera.get_mouse_pos())
		else:
			var v = Input.get_vector("game_target_left", "game_target_right", "game_target_up", "game_target_down")
			if v:
				pointer.look_at(to_global(v))
	if (global_position.y > 10000) or (global_position.y < -10000):
		velocity = Vector2.ZERO
		mask_state = Masks.NONE
		global_position = spawnpoint
	if spent:
		pointer.self_modulate = Color.GREEN
	else:
		pointer.self_modulate = Color.WHITE


#func _input(event: InputEvent) -> void:
#	if event.is_action_pressed("game_debug"):
#		$"../testlines/l1".run()


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
		was_mouse = true
		dir = pointer.transform.basis_xform(Vector2.RIGHT).normalized()
	elif Input.is_action_just_pressed("game_action_controller"):
		var v = Input.get_vector("game_target_left", "game_target_right", "game_target_up", "game_target_down")
		if v:
			pointer.look_at(to_global(v))
		trigger = true
		was_mouse = false
		dir = pointer.transform.basis_xform(Vector2.RIGHT).normalized()
	if trigger:
		match mask_state:
			Masks.NONE:
				pass
			Masks.FOX:
				if not spent:
					velocity = dir * 1040
					spent = true
			Masks.GECKO:
				if not spent:
					obj_grav_dir *= -1
					up_direction.y *= -1
					spent = true
			Masks.BEAR:
				if inrange is Breakable:
					inrange.destroy()
				elif inrange is Throwable:
					inrange.apply_central_impulse(dir * 1010)
			Masks.CAT:
				cata.enabled = catb.enabled
				catb.enabled = !cata.enabled
			Masks.BEETLE:
				if is_on_wall() and not spent:
					velocity = dir * 1010
					spent = true
	if mask_state == Masks.BEETLE:
		if is_on_wall():
			pointer.show()
		else :
			pointer.hide()
		if Input.is_action_pressed("game_jump"):
			if is_on_wall():
				velocity.y = clampf(velocity.y, -absf(velocity.y), 0)
			else:
				velocity.y = clampf(velocity.y, -absf(velocity.y), 100)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if (body is Breakable) or (body is Throwable):
		inrange = body


func _on_area_2d_body_exited(body: Node2D) -> void:
	if inrange == body:
		inrange = null
