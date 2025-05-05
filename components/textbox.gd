extends CanvasLayer


const CHARS:Array[Texture2D] = [
	preload("res://assets/textures/talk/plane1.png"),
	preload("res://assets/textures/talk/plane2.png"),
	preload("res://assets/textures/talk/plane3.png"),
	preload("res://assets/textures/talk/plane4.png"),
]


signal done


@onready var text:RichTextLabel = $Control/VBoxContainer/PanelContainer/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/RichTextLabel
@onready var ico:Sprite2D = $Control/VBoxContainer/PanelContainer/MarginContainer/HBoxContainer/PanelContainer2/MarginContainer/Control/Icon
@onready var speakanim:AnimationPlayer = $AnimationPlayer2


var l:Array[String] = []


func _visibility_changed() -> void:
	GameState.in_text = visible


func _ready() -> void:
	hide()


func _update() -> void:
	if l.size() > 0:
		show()
	else:
		hide()
		done.emit()
		return
	var ln:String = l.pop_at(0)
	text.text = ln
	speakanim.speed_scale = 1.0 / maxf(1, ln.length())
	speakanim.play("a")


func _input(event: InputEvent) -> void:
	if visible:
		if event.is_action_pressed("game_dia_next"):
			get_viewport().set_input_as_handled()
			_update()


func speak(char:int, lines:Array[String]) -> void:
	ico.texture = CHARS[char]
	l = lines.duplicate(true)
	_update()
