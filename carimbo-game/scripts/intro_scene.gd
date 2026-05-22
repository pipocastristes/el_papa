extends Control

@onready var subtitle: Label = $MarginContainer/Subtitle
@onready var music: AudioStreamPlayer2D = $Music
@export var scene: PackedScene
@export var stamp_sfx: AudioStream
const NOITE_CLT = preload("uid://bbh2vyrjcsbgd")

var intro_steps = [
	{"text": "Eu encontrei esse emprego de uma forma meio engraçada", "delay": 2.5},
	{"text": "", "sfx": true, "delay": 0.5},
	{"text": "Um anúncio na deep web. Um trabalho fácil por uma boa quantia de dinheiro", "delay": 3.5},
	{"text": "Tudo o que eu preciso...", "delay": 1.5},
	{"text": "", "pause_music": true, "delay": 1.0},
	{"text": "", "sfx": true, "delay": 1.0},
	{"text": "É CARIMBAR!!!", "delay": 2.0}
]

func _ready() -> void:
	SoundManager.stop_musica()
	subtitle.modulate.a = 0
	run_sequence()

func run_sequence():
	var cont = 0
	for step in intro_steps:
		if cont == 2:
			music.play()
		
		if step.text != "":
			if cont == intro_steps.size() - 1:
				subtitle.add_theme_font_size_override("font_size", 50)
			subtitle.text = step.text
			await fade_text(true)
		
		if step.get('pause_music', false):
			music.stream_paused = true
			
		if step.get('sfx', false):
			SoundManager.play_sfx(stamp_sfx)
			
		await get_tree().create_timer(step.delay).timeout
		
		if step.text != "":
			await fade_text(false)
		
		cont += 1
		
	get_tree().change_scene_to_packed(scene)
	SoundManager.change_musica(NOITE_CLT, false, true)

func fade_text(show_text: bool):
	var tween = create_tween()
	if show_text:
		subtitle.modulate.a = 1.0
		subtitle.visible_ratio = 0
		
		var type_time = subtitle.text.length() * 0.04
		await tween.tween_property(subtitle, "visible_ratio", 1, type_time).finished
	else:
		await tween.tween_property(subtitle, "modulate:a", 0.0, 0.5).finished
