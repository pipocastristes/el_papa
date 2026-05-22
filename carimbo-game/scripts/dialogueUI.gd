extends CanvasLayer

var dialogue_queue: Array = []
var in_run: bool = false
var block_input: bool = false

@onready var color_rect: ColorRect = $MarginContainer/ColorRect
@onready var label: Label = $MarginContainer/ColorRect/Label
@export var dialogues_stream: Array[AudioStream]

func start(dialogues: Array, block := true):
	if not is_node_ready():
		await ready
		
	dialogue_queue = dialogues.duplicate()
	block_input = block
	in_run = true
	
	color_rect.visible = true
	_show_next()

func _show_next():
	if dialogue_queue.is_empty():
		_finish_dialogue()
		return

	var line = dialogue_queue.pop_front()
	label.text = line.get("text", "")
	
	label.visible_ratio = 0

	if not dialogues_stream.is_empty():
		var sfx = dialogues_stream[randi() % dialogues_stream.size()]
		SoundManager.play_sfx(sfx)

	var tween = create_tween()
	var read_time = max(1.0, label.text.length() * 0.03)
	tween.tween_property(label, "visible_ratio", 1, read_time)

	if not block_input:
		await tween.finished
		await get_tree().create_timer(1.0).timeout
		if in_run: 
			_show_next()

func _input(event):
	if not in_run or not block_input:
		return

	if event.is_action_pressed("ui_accept") or (event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT):
		if label.visible_ratio < 1:
			label.visible_ratio = 1
		else:
			_show_next()

func _finish_dialogue():
	color_rect.visible = false
	in_run = false
	DialogueManager.finish_dialogue()
