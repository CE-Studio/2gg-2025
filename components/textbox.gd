extends CanvasLayer


@onready var text:RichTextLabel = $Control/VBoxContainer/PanelContainer/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/RichTextLabel
@onready var ico:Sprite2D = $Control/VBoxContainer/PanelContainer/MarginContainer/HBoxContainer/PanelContainer2/MarginContainer/Control/Icon


func _ready() -> void:
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
