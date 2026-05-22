extends Node2D
class_name Letter

var current_letter_resource: LetterResource = null
var current_position: Vector2
var current_size: Vector2

var correct_stamp: String = ''
var applied_stamp: String = ''

var dragging: bool = false
var letter_open: bool = false
var offset: Vector2

var is_focused: bool = false
var in_transition: bool = false

@export var marks: Array[Texture] = []
@onready var desenho: Sprite2D = $Desenho
@onready var background: Sprite2D = $Background
@onready var text_label: Label = $Text
@onready var envelope: AnimatedSprite2D = $Envelope
@onready var envelope_shape: CollisionShape2D = $AreaDetectorEnvelope/CollisionShape2D
@onready var area_detector_stamp: Area2D = $AreaDetectorStamp
@onready var text_aux: Label = $TextAux
@onready var stamp_mark: Sprite2D = $StampMark

var type_sprite: String = 'boa'

signal letter_stashed(res: LetterResource)

func _process(_delta: float) -> void:
	if is_mouse_over():
		Input.set_default_cursor_shape(Input.CURSOR_MOVE)
	else:
		Input.set_default_cursor_shape(Input.CURSOR_ARROW)

func _ready() -> void:
	current_size = scale

func _input(event: InputEvent) -> void:
	var desk: Desk = get_tree().current_scene

	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			if event.pressed:
				if is_mouse_over() and letter_open:
					toggle_focus()
						
		if event.button_index == MOUSE_BUTTON_LEFT:
			if is_focused:
				if event.pressed and not is_mouse_over():
					toggle_focus()
					return
	if not is_focused:
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT:
				if event.pressed:
					if desk.held_stamp != null and is_mouse_over_stamp() and applied_stamp == '':
						apply_mark(desk.held_stamp.type, get_local_mouse_position())
						desk.held_stamp.apply_mark()
						get_viewport().set_input_as_handled()
						return

					if is_mouse_over() and desk.held_stamp == null:
						dragging = true;
						offset = global_position - get_global_mouse_position()
				else:
					dragging = false
					check_drop()

	if event is InputEventMouseMotion and dragging:
		global_position = get_global_mouse_position() + offset


func toggle_focus():
	EventManager.player_entered_reading_mode.emit()
	
	var desk: Desk = get_tree().current_scene
	var camera: Camera2D = desk.get_node("DeskCamera")
	
	is_focused = !is_focused
	desk.in_focus_mode = is_focused
	in_transition = true
	
	var tween = create_tween().set_parallel()
	if is_focused:
		current_position = position
		current_size = scale
		
		var camera_center = camera.global_position
		
		tween.tween_property(self, "scale", Vector2(1.3, 1.3), 0.3).set_trans(Tween.TRANS_QUART)
		tween.tween_property(self, "global_position", camera_center, 0.3)
		z_index = 101

		await tween.finished
		text_aux.visible = true
	else:
		tween.tween_property(self, "scale", current_size, 0.3)
		tween.tween_property(self, "global_position", current_position, 0.3)
		z_index = 1
		text_aux.visible = false

	await tween.finished
	in_transition = false

func check_drop():
	var desk: Desk = get_parent()

	if is_focused or in_transition or desk.in_focus_mode:
		return

	var areas = $AreaDetectorEnvelope.get_overlapping_areas()
	
	if desk.send_area in areas:
		desk.validate_letter(self)
	elif desk.tashed_area in areas and GameManager.stash_unlocked:
		stash_letter()
		
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)

func stash_letter():
	letter_stashed.emit(current_letter_resource)
	queue_free()

func show_feedback(correct: bool):
	if correct:
		envelope.modulate = Color(0.6, 1, 0.6)
	else:
		envelope.modulate = Color(1, 0.5, 0.5)

func is_mouse_over_stamp() -> bool:
	var desk: Desk = get_tree().current_scene
	
	if desk.held_stamp == null:
		return false
	
	return area_detector_stamp.overlaps_area(desk.held_stamp)

func is_mouse_over() -> bool:
	var local_mouse = to_local(get_global_mouse_position())
	
	if letter_open:
		var rect = background.get_rect()
		return rect.has_point(local_mouse)
	else:
		var rect = envelope_shape.shape.get_rect()
		var detector_pos = $AreaDetectorEnvelope.position + envelope_shape.position
		var final_rect = Rect2(rect.position + detector_pos, rect.size)
		return final_rect.has_point(local_mouse)

func setup_from_resource(res: LetterResource, pos: Vector2):
	area_detector_stamp.monitoring = false
	current_letter_resource = res
	if current_letter_resource.is_suspicious:
		type_sprite = 'ruim'
	envelope.play("idle_close_" + type_sprite)
	background.visible = false
	text_label.visible = false
	stamp_mark.visible = false
	text_aux.visible = false
	desenho.visible = false
	desenho.texture = res.texture

	var tween = create_tween()
	await tween.tween_property(self, "global_position", pos, 0.8).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT).finished

	envelope.play("open_" + type_sprite)
	envelope.animation_finished.connect(_on_open_finished, CONNECT_ONE_SHOT)

func _on_open_finished():
	background.visible = true
	text_label.visible = true
	text_label.text = current_letter_resource.content
	text_aux.text = current_letter_resource.content
	correct_stamp = current_letter_resource.correct_stamp
	letter_open = true
	desenho.visible = true
	area_detector_stamp.monitoring = true

	envelope.play("idle_open_" + type_sprite)
	var tween = create_tween().set_parallel(true)
	tween.tween_property(envelope, "position", Vector2(-150, -50), 0.4).set_trans(Tween.TRANS_QUART).set_ease(Tween.EaseType.EASE_OUT)
	tween.tween_property(envelope, "rotation_degrees", -15.0, 0.4)
	tween.tween_property(envelope, "modulate:a", 0.6, 0.4)

func apply_mark(stamp_type: String, pos: Vector2):
	EventManager.player_stamped_letter.emit()
	
	if applied_stamp != '':
		return

	applied_stamp = stamp_type
	
	if applied_stamp == 'coal':
		stamp_mark.texture = marks[1]
	else:
		stamp_mark.texture = marks[0]
	
	stamp_mark.visible = true
	stamp_mark.position = Vector2(pos.x, pos.y + 35)

	var mark_tween = create_tween()
	mark_tween.tween_property(self, "scale", scale * 1.05, 0.05)
	mark_tween.tween_property(self, "scale", scale, 0.05)	
	
	if get_tree().current_scene.has_node("DeskCamera"):
			get_tree().current_scene.get_node("DeskCamera").shake(3.0)
	
	await get_tree().create_timer(0.5).timeout
	
	letter_open = false
	
	var tween = create_tween().set_parallel(true)
	tween.tween_property(envelope, "modulate:a", 1.0, 0.4)
	tween.tween_property(envelope, "rotation_degrees", 0.0, 0.4)
	tween.tween_property(envelope, "position", Vector2(-1.35, 59.20), 0.4).set_trans(Tween.TRANS_QUART).set_ease(Tween.EaseType.EASE_IN)
	
	await tween.finished
	
	background.visible = false
	stamp_mark.visible = false
	text_label.visible = false
	desenho.visible = false
	
	envelope.play("close_" + type_sprite)


func _on_area_detector_envelope_area_entered(area: Area2D) -> void:
	var desk: Desk = get_tree().current_scene

	if dragging:
		if area == desk.send_area and applied_stamp != '':
			apply_hover_feedback(Color(1.2, 1.2, 0.8), Vector2(0.90, 0.90))
		elif area == desk.tashed_area and GameManager.stash_unlocked:
			apply_hover_feedback(Color(1.2, 0.8, 1.2), Vector2(0.90, 0.90))

func _on_area_detector_envelope_area_exited(area: Area2D) -> void:
	var desk: Desk = get_tree().current_scene
	
	if area == desk.send_area or area == desk.tashed_area:
		if not is_focused:
			apply_hover_feedback(Color(1, 1, 1), current_size)
	
func apply_hover_feedback(target_color: Color, target_scale: Vector2):
	var tween = create_tween()
	tween.tween_property(self, 'modulate', target_color, 0.1)
	tween.tween_property(self, "scale", target_scale, 0.1)
	
