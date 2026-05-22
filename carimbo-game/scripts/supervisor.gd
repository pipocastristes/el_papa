extends Interagivel

func _ready():
	super._ready()
	DialogueManager.dialogue_started.connect(_on_dialogue_started)
	DialogueManager.dialogue_finished.connect(_on_dialogue_finished)

func _on_dialogue_started():
	DialogueManager.block_input = true

func _on_dialogue_finished():
	DialogueManager.block_input = false

	if GameManager.day == 1:
		GameManager.next_day()
		GameManager.pode_levantar = false
	elif GameManager.day == 2:
		var cenario_batalha = preload("uid://bsce6tf6ehlh4").instantiate()
		cenario_batalha.inimigo = BatalhasManager.INIMIGOS.SUPERVISOR
		get_tree().change_scene_to_node(cenario_batalha)

func _on_body_entered(body):
	if GameManager.objetivo_atual != Constants.OBJETIVOS.ENCONTRAR_SUPERVISOR:
		return
		
	super._on_body_entered(body)
	
func interagir(_player):
	monitoring = false

	if GameManager.day == 1:
		DialogueManager.start_dialogue(Constants.DIALOGOS["SUPERVISOR_01"], true)
	elif GameManager.day == 2:
		DialogueManager.start_dialogue(Constants.DIALOGOS["SUPERVISOR_02"], true)
