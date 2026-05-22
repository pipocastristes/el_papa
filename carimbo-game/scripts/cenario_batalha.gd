extends Node2D

@onready var enemy_supervisor: AnimatedSprite2D = $enemy_supervisor
@onready var enemy_elfo: AnimatedSprite2D = $enemy_elfo
@onready var enemy_elfo_sup: AnimatedSprite2D = $enemy_elfo_sup
@onready var enemy_mama_noel: AnimatedSprite2D = $enemy_mama_noel
@onready var enemy_papa_noel: AnimatedSprite2D = $enemy_papa_noel

@onready var tela_batalha: CanvasLayer = $tela_batalha
@export var inimigo: BatalhasManager.INIMIGOS
const CREDITOS = preload(Constants.UID_SCENES[Constants.TELAS.TELA_CREDITOS])

var enemy: AnimatedSprite2D

const MUSICA = preload("uid://bssweesetteg2")
const TELA_PAUSE = preload(Constants.UID_SCENES[Constants.TELAS.TELA_PAUSE])

func _ready() -> void:
	SoundManager.change_musica(MUSICA, false, true)
	_define_inimigo()

func _input(event: InputEvent) -> void:
	if (event is InputEventKey || (event is InputEventMouseButton && event.pressed)):
		_pausar_jogo(event)

func _pausar_jogo(event: InputEvent):
	if (event.is_action_pressed("ui_cancel") and not get_tree().paused):
		get_tree().paused = true
		var tela_pause = TELA_PAUSE.instantiate()
		add_child(tela_pause)
		await tela_pause.continuar_selected
		tela_pause.queue_free()

func _define_inimigo():
	tela_batalha.set_inimigo(inimigo)
	enemy_supervisor.visible = false
	enemy_elfo.visible = false
	enemy_elfo_sup.visible = false
	enemy_mama_noel.visible = false
	enemy_papa_noel.visible = false
	match inimigo:
		BatalhasManager.INIMIGOS.SUPERVISOR:
			enemy = enemy_supervisor
		BatalhasManager.INIMIGOS.ELFO:
			enemy = enemy_elfo
		BatalhasManager.INIMIGOS.ELFO_SUP:
			enemy = enemy_elfo_sup
		BatalhasManager.INIMIGOS.MAMA_NOEL:
			enemy = enemy_mama_noel
		BatalhasManager.INIMIGOS.PAPA_NOEL:
			enemy = enemy_papa_noel
	enemy.visible = true
	enemy.play("default")

func _on_tela_batalha_enemy_damaged() -> void:
	enemy.play("damaged")
	await enemy.animation_finished
	enemy.play("default")
	await enemy.animation_finished

func _on_tela_batalha_batalha_finalizada(_vitoria: bool) -> void:
	enemy.play("win")
	get_tree().change_scene_to_packed(CREDITOS)
