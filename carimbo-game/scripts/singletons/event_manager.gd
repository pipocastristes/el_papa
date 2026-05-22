extends Node


# Sinais de Tutorial
@warning_ignore_start("unused_signal")
signal player_opened_letter
signal player_entered_reading_mode
signal player_get_stamp
signal player_stamped_letter(type: String)
signal player_sent_letter
signal player_leave
signal player_moved
@warning_ignore_restore("unused_signal")

# Sinais de Eventos
signal letter_spawned(resource: LetterResource)
signal day_started(day: int)
signal letter_resolved(res: LetterResource, decision: String)
signal stash_unlocked_event
signal event_started(event_id)
signal player_can_leave_desk

var current_event: String = ''

func _ready() -> void:
	letter_spawned.connect(_on_letter_spawned)
	day_started.connect(_on_day_started)
	letter_resolved.connect(_on_letter_resolved)
	stash_unlocked_event.connect(_on_stash_unlocked)

func check_for_day_event():
	var day = GameManager.day
	var route = GameManager.get_route()

	match day:
		3:
			if route == "doubt":
				start_event("first_doubt")
			elif route == "rebel":
				start_event("secret_signal")
		5:
			if route == "rebel":
				start_event("inspection_warning")
		6:
			start_event("final_evaluation")
			
func start_event(event_id: String):
	current_event = event_id
	emit_signal("event_started", event_id)
	print("Evento iniciado:", event_id)
	
func _on_letter_spawned(res: LetterResource):
	match res.sender_name:
		"Lívia":
			DialogueManager.start_dialogue(Constants.DIALOGOS.LIVIA, false)
		"Benjamin":
			DialogueManager.start_dialogue(Constants.DIALOGOS.BENJAMIN, false)
			if not DialogueManager.dialogue_finished.is_connected(_on_benjamin_event_finished):
				DialogueManager.dialogue_finished.connect(_on_benjamin_event_finished)

func _on_benjamin_event_finished():
	DialogueManager.dialogue_finished.disconnect(_on_benjamin_event_finished)
	GameManager.set_objetivo(Constants.OBJETIVOS.ENCONTRAR_SUPERVISOR)
	GameManager.pode_levantar = true
	GameManager.tutorial = true
	player_can_leave_desk.emit()

func _on_day_started(day: int):
	if day == 1 and GameManager.tutorial:
		DialogueManager.start_dialogue(Constants.DIALOGOS.INTRO_DIA_1, false)
		GameManager.start_tutorial()
		GameManager.tutorial = true

func _on_letter_resolved(res: LetterResource, decision: String):
	if res.sender_name == "Thiago" and decision == "stash":
		DialogueManager.start_dialogue(Constants.DIALOGOS.THIAGO_FINISH, false)

func _on_stash_unlocked():
	DialogueManager.start_dialogue(Constants.DIALOGOS.UNLOCK_STASH, false)
