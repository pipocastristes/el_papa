extends CanvasLayer
class_name Tutorial

class TutorialSteps:
	var text: String
	var sound: AudioStream
	
	func _init(t: String, s: AudioStream) -> void:
		text = t
		sound = s

@onready var label: Label = $MarginContainer/VBoxContainer/HBoxContainer/Label
@export var streams: Array[AudioStream]
var steps: Array[TutorialSteps]
var current_step: int = 0

func _ready() -> void:
	steps = [
		TutorialSteps.new("CLIQUE NO ENVELOPE COM [LMB] PARA ABRIR", streams[0]),
		TutorialSteps.new("CLIQUE NA CARTA COM [RMB] PARA ENTRAR/SAIR DO MODO LEITURA", streams[1]),
		TutorialSteps.new("CLIQUE EM UM DOS CARIMBOS COM [LMB] PARA SELECIONAR", streams[2]),
		TutorialSteps.new("COM O CARIMBO EM MÃOS CLIQUE NA CARTA COM [LMB] PARA MARCAR", streams[1]),
		TutorialSteps.new("ARRASTE O ENVELOPE ATÉ O CORREIO PARA ENVIAR", streams[2]),
		TutorialSteps.new("PRESSIONE [Q] PARA SAIR DA MESA E PROCURAR O SUPERVISOR", streams[1]),
		TutorialSteps.new("USE [A]/[D] PARA SE MOVIMENTAR", streams[2])
	]
	
	EventManager.player_opened_letter.connect(_on_action_performed.bind(0))
	EventManager.player_entered_reading_mode.connect(_on_action_performed.bind(1))
	EventManager.player_get_stamp.connect(_on_action_performed.bind(2))
	EventManager.player_stamped_letter.connect(_on_action_performed.bind(3))
	EventManager.player_sent_letter.connect(_on_action_performed.bind(4))
	EventManager.player_can_leave_desk.connect(_on_action_perfomed_2d.bind(5))
	EventManager.player_leave.connect(_on_action_perfomed_2d.bind(6))
	EventManager.player_moved.connect(_on_action_perfomed_2d.bind(7))

	update_tutorial_text()

func _on_action_performed(step_index: int):
	if current_step > 4 and step_index <= 4:
		return

	if step_index == current_step:
		current_step += 1

		if step_index == 4:
			clear()
			return

		if current_step < steps.size():
			update_tutorial_text()

func _on_action_perfomed_2d(step_index: int):
		current_step = step_index

		if current_step < steps.size():
			update_tutorial_text()
		elif current_step >= steps.size():
			clear()

func update_tutorial_text():
	var step = steps[current_step]
	label.text = step.text
	SoundManager.play_sfx(step.sound)
	
func clear():
	GameManager.tutorial = false
	label.text = ''
