extends Node

signal objetivo_atualizado(texto)
# signal day_started(day)
# signal day_finished(success)
# signal game_over

var day: int = 1
var game_level: int = 1
var letters_processed: int = 0
var objetivo_atual: Constants.OBJETIVOS

var stash_unlocked := false
var pode_levantar := false
var el_papa_foto := false
var trocando_sala := false

var score: int = 0
var suspicion: int = 0
var humanity: int = 50
var child_bond: int = 50

var required_score: int = 5
var max_letters_day: int = 7
var max_errors: int = 2

var suspicious_letters: Array[LetterResource] = []
var suspicious_stashed_total: int = 0

var tutorial := true
var tutorial_instance
var tutorial_scene = preload(Constants.UID_SCENES[Constants.TELAS.TUTORIAL])

func get_route() -> String:
	if suspicious_stashed_total == 0:
		return "obedient"
	if suspicious_stashed_total < 5:
		return "doubt"
	else:
		return "rebel"

func set_objetivo(novo_objetivo: Constants.OBJETIVOS):
	objetivo_atual = novo_objetivo
	var text = Constants.OBJETIVOS_TEXTOS.get(novo_objetivo, "")
	emit_signal("objetivo_atualizado", text)

func start_tutorial():
	tutorial_instance = tutorial_scene.instantiate()
	get_tree().root.add_child.call_deferred(tutorial_instance)

func finish_tutorial():
	if tutorial_instance:
		tutorial_instance.queue_free()
		tutorial_instance = null
		tutorial = false
		
func next_level():
	game_level += 1
	print("Next level: ", game_level)
		
func next_day():
	day += 1
	print("Next day: ", day)
