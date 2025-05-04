class_name GameState
extends RefCounted


static var in_text := false
static var accepting_input := true
static var paused := false


static func is_accepting_input() -> bool:
	return accepting_input and (not paused) and (not in_text)
