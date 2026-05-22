extends CharacterBody2D
class_name Player 


@export var speed: float = 300.0

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var interacao_prompt: Node2D = $Interação
@onready var ui_label: LabelUI = get_tree().get_first_node_in_group("ui_label")

var interagivel_atual: Interagivel = null

func _ready() -> void:
	interacao_prompt.visible = false

func _physics_process(_delta):
	if DialogueManager.block_input || GameManager.trocando_sala:
		return
	
	if interagivel_atual and Input.is_action_just_pressed("interagir"):
		if interagivel_atual.pode_interagir(self):
			interagivel_atual.interagir(self)
	
	var direction := 0
	
	if Input.is_action_pressed("para_direita"):
		direction += 1
	if Input.is_action_pressed("para_esquerda"):
		direction -= 1

	if direction != 0 and GameManager.tutorial:
			EventManager.player_moved.emit()

	# Movimento horizontal
	velocity.x = direction * speed
	move_and_slide()

	# Animações
	if direction == 0:
		sprite.play("idle")
	else:
		sprite.play("walk")
		sprite.flip_h = direction > 0
		
func mostrar_prompt_interacao(ativo: bool):
	interacao_prompt.visible = ativo

	if ativo and interagivel_atual:
		ui_label.show_label(interagivel_atual.texto_interacao)
	else:
		ui_label.clear_label()
