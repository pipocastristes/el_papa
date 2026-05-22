extends CanvasLayer

@onready var fade_rect: ColorRect = $ColorRect

var is_transi: bool = false
var target_scene: String

var fade_out_time := 0.25
var fade_in_time := 0.35

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	fade_rect.modulate.a = 0.0
	
func change_scene(scene_path: String) -> void:
	if is_transi:
		return
		
	is_transi = true
	target_scene = scene_path
	
	_start_fade_out()
	

func _start_fade_out() -> void:
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	
	tween.tween_property(fade_rect, "modulate:a", 1.0, fade_out_time)
	tween.finished.connect(_on_fade_out_finished)

func _on_fade_out_finished() -> void:
	get_tree().change_scene_to_file(target_scene)
	await  get_tree().process_frame
	
	_start_fade_in()

func _start_fade_in() -> void:
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	
	tween.tween_property(fade_rect, "modulate:a", 0.0, fade_in_time)
	tween.finished.connect(_on_fade_in_finished)
	
func _on_fade_in_finished() -> void:
	is_transi = false
