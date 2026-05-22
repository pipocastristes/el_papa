extends Node2D
class_name DeskLetter

var letter_index: int = 0
@export var slide_stream: AudioStream

func create_letter():
	var desk: Desk = get_tree().current_scene
	
	if desk.current_letter:
		return
	
	SoundManager.play_sfx(slide_stream)
	var tween = create_tween()
	await tween.tween_property(self, "global_position", Vector2(position.x, position.y + 650), 0.6).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN).finished
	
	await get_tree().create_timer(0.5).timeout
	
	desk.generate_latter(letter_index)
	self.queue_free()


func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				var desk: Desk = get_tree().current_scene
				
				if z_index != desk.get_top_letter():
					return
				
				get_viewport().set_input_as_handled()
				
				if desk.current_letter:
					return
					
				create_letter()
				
				EventManager.player_opened_letter.emit()


func _on_area_2d_mouse_entered() -> void:
	var desk: Desk = get_tree().current_scene
	if z_index != desk.get_top_letter():
		return
	
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(1.08, 1.08, 1.08, 1), 0.15)

func _on_area_2d_mouse_exited() -> void:
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(1, 1, 1, 1), 0.15)
