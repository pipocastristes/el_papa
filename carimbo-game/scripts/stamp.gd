extends Area2D
class_name Stamp

@onready var sprite_2d: Sprite2D = $Sprite2D

@export_enum("gift", "coal") var type: String = 'gift'
@export var sprites: Array[Texture] = []
@export var get_stream: AudioStream
var initial_position: Vector2
var is_held: bool = false

var current_scale: Vector2

func _ready() -> void:
	initial_position = position
	current_scale = scale
	monitoring = false
	sprite_2d.texture = sprites[0]

func _process(delta: float) -> void:
	if is_held:
		global_position = global_position.lerp(get_global_mouse_position(), delta * 25)
		monitoring = true

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		var desk: Desk = get_tree().current_scene
		
		if not is_held:
			if desk.held_stamp and desk.held_stamp != self and not desk.in_focus_mode:
				desk.held_stamp.return_home()
				
			pick_up()
		else:
			return_home()

func apply_mark():
	sprite_2d.texture = sprites[1]
	await get_tree().create_timer(0.05).timeout
	sprite_2d.texture = sprites[0]
	await get_tree().create_timer(0.05).timeout
	return_home()

func pick_up():
	EventManager.player_get_stamp.emit()
	
	SoundManager.play_sfx(get_stream)
	is_held = true
	z_index = 20
	var desk: Desk = get_tree().current_scene
	desk.held_stamp = self
	desk.held_type = type

func return_home():
	is_held = false
	z_index = 1
	monitoring = false
	var desk: Desk = get_tree().current_scene
	if desk.held_stamp == self:
		desk.held_stamp = null
		desk.held_type = ''
		
	var tween = create_tween()
	tween.tween_property(self, "position", initial_position, 0.5).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", current_scale, 0.3)

func _on_area_entered(area: Area2D) -> void:
	if area.name == 'AreaDetectorStamp':
		var tween = create_tween()
		tween.tween_property(self, "scale", current_scale * 1.05, 0.1)
		modulate = Color(1.2, 1.2, 1.2)

func _on_area_exited(area: Area2D) -> void:
	if area.name == 'AreaDetectorStamp':
		var tween = create_tween()
		tween.tween_property(self, "scale", current_scale, 0.1)
		modulate = Color(1, 1, 1)

func _on_mouse_entered() -> void:
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(1.08, 1.08, 1.08, 1), 0.15)

func _on_mouse_exited() -> void:
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(1, 1, 1, 1), 0.15)
