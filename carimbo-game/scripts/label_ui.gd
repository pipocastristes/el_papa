extends CanvasLayer
class_name LabelUI

@onready var label: Label = $MarginContainer/Label

func _ready() -> void:
	label.visible = false

func show_label(text: String):
	label.text = text
	label.visible = true

func clear_label():
	label.text = ''
	label.visible = false
