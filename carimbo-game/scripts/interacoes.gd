extends Node

@export var text: String = ''
var in_dialogue: bool = false

func _ready() -> void:
	DialogueManager.dialogue_finished.connect(_on_dialogue_finished)

func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				start_dialogue() 

func _on_dialogue_finished():
	if in_dialogue:
		in_dialogue = false

func start_dialogue():
	if in_dialogue || GameManager.tutorial:
		return
		
	DialogueManager.start_dialogue([{ "text": text }], false)

func _on_area_2d_mouse_entered() -> void:
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(1.08, 1.08, 1.08, 1), 0.15)

func _on_area_2d_mouse_exited() -> void:
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(1, 1, 1, 1), 0.15)
