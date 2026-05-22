extends Node2D
class_name Desk

@onready var emotrometro: Emotrometro = $Emotrometro
@onready var send_area: Area2D = $SendArea
@onready var tashed_area: Area2D = $TashedArea
@onready var send_area_sprite: AnimatedSprite2D = $SendArea/AnimatedSprite2D
@onready var letter_final_spawn: Node2D = $LetterFinalSpawn
@onready var letter_pile_spawn: Node2D = $LetterPileSpawn
const TELA_PAUSE = preload(Constants.UID_SCENES[Constants.TELAS.TELA_PAUSE])

@export_category("Configurações de Progressão")
var required_score: int = 5
var suspicious_tashed: int = 0

@export_category('Configuração de Cena')
@export var letter_scene: PackedScene = null
var day_letters: Array[LetterResource]
@export var day_one_letters: Array[LetterResource]
@export var day_two_latters: Array[LetterResource]
@export var desk_letter_scene: PackedScene = null
var current_letter_resource: LetterResource = null
var current_letter: Node = null

@onready var desk_background: Sprite2D = $DeskBackground
@export var sprite_closed: Texture
@export var sprites: Array[Texture] = []

var current_letter_correct_stamp: String = ''
var selected_stamp: String = ''

var held_stamp: Stamp = null
var held_type: String = ''

var in_focus_mode: bool = false

var intro_phase: int = 0
var intro_active: bool = true

func _ready() -> void:
	DialogueManager.dialogue_started.connect(_on_dialogue_started)
	DialogueManager.dialogue_finished.connect(_on_dialogue_finished)

	if GameManager.game_level == 1:
		day_letters = day_one_letters
		EventManager.day_started.emit(1)
	elif GameManager.game_level == 2:
		if GameManager.objetivo_atual == Constants.OBJETIVOS.VOLTAR_TRABALHAR:
			GameManager.set_objetivo(Constants.OBJETIVOS.JULGAR_OUTRAS_CARTAS)
		
		day_letters = day_two_latters
		GameManager.tutorial = false
		call_deferred("unlock_stash")
	
	desk_background.texture = sprite_closed
	send_area_sprite.play("idle")
	tashed_area.monitoring = GameManager.stash_unlocked

	for i in day_letters.size():
		var desk_letter: DeskLetter = desk_letter_scene.instantiate()
		add_child(desk_letter)
		desk_letter.global_position = Vector2(letter_pile_spawn.position.x + 20 * i, letter_pile_spawn.position.y)
		desk_letter.rotation_degrees = randi_range(-20, 20)
		desk_letter.letter_index = i
		desk_letter.z_index = i + 1

func _input(event: InputEvent) -> void:
	
	if (event is InputEventKey || (event is InputEventMouseButton && event.pressed)):
		_pausar_jogo(event)
		
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_Q:
			if GameManager.pode_levantar:
				levantar()

func _pausar_jogo(event: InputEvent):
	if (event.is_action_pressed("ui_cancel") and not get_tree().paused):
		get_tree().paused = true
		var tela_pause = TELA_PAUSE.instantiate()
		add_child(tela_pause)
		await tela_pause.continuar_selected
		tela_pause.queue_free()

func levantar():
	if GameManager.pode_levantar:
		EventManager.player_leave.emit()
		TransitionManager.change_scene(Constants.UID_SCENES[Constants.TELAS.WORLD])

func generate_latter(letter_index: int) -> void:
	if current_letter != null or day_letters.is_empty():
		return
	
	current_letter_resource = day_letters[letter_index]
	
	EventManager.letter_spawned.emit(current_letter_resource)
	
	current_letter = letter_scene.instantiate()
	add_child(current_letter)
	current_letter.global_position = $LetterSpawn.global_position
	current_letter.letter_stashed.connect(_on_letter_stashed)
	current_letter.setup_from_resource(current_letter_resource, letter_final_spawn.position)

func score_update(value: int):
	GameManager.score += value
	emotrometro.update_emot(GameManager.score)
	
	if value < 0:
		$DeskCamera.shake(2.0)

func validate_letter(letter):
	if letter.applied_stamp == '':
		return
		
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
	
	var correct = letter.applied_stamp == letter.correct_stamp
	letter.queue_free()
	send_area_sprite.play("send_letter")
	await get_tree().create_timer(0.3).timeout

	resolve_letter(current_letter_resource, "send", correct)
	
	send_area_sprite.play("idle")
	current_letter = null
	current_letter_resource = null

func check_day_end():
	if GameManager.letters_processed >= GameManager.max_letters_day:
		end_day()
	
	if GameManager.score < -GameManager.max_errors:
		game_over()

func end_day():
	if GameManager.score >= required_score:
		next_day()
	else:
		game_over()

func next_day():
	GameManager.day += 1
	GameManager.letters_processed = 0
	score_update(0)
	required_score += 2
	GameManager.max_letters_day += 3
	EventManager.check_for_day_event()

func game_over():
	GameManager.day = 0

func _on_letter_stashed(res: LetterResource) -> void:
	resolve_letter(res, "stash")
	current_letter = null

func get_top_letter() -> int:
	var max_z = -999
	
	for child in get_children():
		if child is DeskLetter:
			if child.z_index > max_z:
				max_z = child.z_index
				
	return max_z

func _on_pile_button_pressed() -> void:	
	generate_latter(0)

func resolve_letter(res: LetterResource, decision: String, correct: bool = false):
	EventManager.player_sent_letter.emit()
	EventManager.letter_resolved.emit(res, decision)
	
	match decision:
		"send":
			if correct:
				score_update(1)
				GameManager.humanity += res.moral_weight
			else:
				score_update(-1)
				GameManager.humanity -= res.moral_weight

			GameManager.suspicion += res.suspicion_weight

		"stash":
			if res.is_suspicious:
				GameManager.suspicious_letters.append(res)
				GameManager.suspicious_stashed_total += 1
				GameManager.suspicion -= 1
			else:
				score_update(-2)
				GameManager.suspicion += 2

			suspicious_tashed += 1

	desk_background.texture = sprite_closed
	GameManager.letters_processed += 1

func unlock_stash():
	EventManager.stash_unlocked_event.emit()
	GameManager.stash_unlocked = true
	tashed_area.monitoring = true

func _on_tashed_area_area_entered(area: Area2D) -> void:
	if area.name == "AreaDetectorEnvelope" and not in_focus_mode and GameManager.stash_unlocked:
		if suspicious_tashed == 0:
			desk_background.texture = sprites[0]
		elif suspicious_tashed >= 1 and suspicious_tashed < 3:
			desk_background.texture = sprites[1]
		elif suspicious_tashed >= 3 and suspicious_tashed < 5:
			desk_background.texture = sprites[2]
		elif suspicious_tashed >= 5:
			desk_background.texture = sprites[3]

func _on_tashed_area_area_exited(area: Area2D) -> void:
	if area.name == "AreaDetectorEnvelope":
		desk_background.texture = sprite_closed

func _on_dialogue_started():
	if DialogueManager.block_input:
		in_focus_mode = true
	
func _on_dialogue_finished():
	if DialogueManager.block_input:
		in_focus_mode = false
		
	if GameManager.day == 2 and GameManager.objetivo_atual == Constants.OBJETIVOS.JULGAR_OUTRAS_CARTAS:
		desk_background.texture = sprites[0]
