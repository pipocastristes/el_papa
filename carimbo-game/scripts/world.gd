extends Node2D

@onready var player: Player = $Felco
@onready var sala_container: Node2D = $SalaContainer
@onready var fade_rect: ColorRect = $FadeLayer/ColorRect

var sala_atual: SalaBase

func _ready() -> void:
	fade_rect.modulate.a = 0
	trocar_sala(
		Constants.UID_CENAS[Constants.CENAS_ORDENADAS.ESCRITORIO], 
		"inicio", 
		false
	)

func trocar_sala(scene_path: String, spawn_id: String, fade := true):
	if GameManager.trocando_sala:
		return
		
	GameManager.trocando_sala = true
	
	if fade:
		await _fade_out()
	
	if sala_atual:
		sala_atual.on_exit()
		sala_atual.queue_free()
		
	var nova_sala: SalaBase = load(scene_path).instantiate()
	sala_container.add_child(nova_sala)
	sala_atual = nova_sala
	sala_atual.trocar_sala.connect(trocar_sala)
	sala_atual.on_enter()
	posicionar_player(spawn_id)
	
	if fade:
		await get_tree().create_timer(0.05).timeout
		await _fade_in()
		
	GameManager.trocando_sala = false
	
func posicionar_player(spawn_id: String):
	if !sala_atual:
		return
		
	var spawn = sala_atual.get_spawn(spawn_id)
	
	if spawn:
		player.global_position = spawn.global_position
		
func _fade_out():
	var tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(fade_rect, "modulate:a", 1.0, 0.25)
	await tween.finished
	
func _fade_in():
	var tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	tween.tween_property(fade_rect, "modulate:a", 0.0, 0.25)
	await tween.finished
