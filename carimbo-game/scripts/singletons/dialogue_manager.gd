extends Node

signal dialogue_started
signal dialogue_finished

var dialogue_scene: PackedScene = preload("res://telas/dialogueUI.tscn")
var dialogue_instance
var block_input: bool = false

func start_dialogue(dialogues: Array, block := true):
	if dialogue_instance != null:
		return
		
	block_input = block
	
	dialogue_instance = dialogue_scene.instantiate()
	get_tree().root.add_child.call_deferred(dialogue_instance)
	
	dialogue_instance.start(dialogues, block)
	
	dialogue_started.emit()


func finish_dialogue():
	if dialogue_instance:
		dialogue_instance.queue_free()
		dialogue_instance = null
	
	dialogue_finished.emit()
