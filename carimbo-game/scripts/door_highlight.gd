extends Interagivel
class_name DoorHighlight

@export var cena_destino: Constants.CENAS_ORDENADAS
@export var spawn_destino: String
@export var max_highlight := 0.2

@onready var destaques: Node2D = $Destaques

func _ready():
	super._ready()

	for child in destaques.get_children():
		child.modulate.a = 0

func _on_body_entered(body):
	super._on_body_entered(body)

	if body.is_in_group("player"):
		_highlight(max_highlight, destaques)
		
func _on_body_exited(body):
	super._on_body_exited(body)

	if body.is_in_group("player"):
		_highlight(0, destaques)

func interagir(_player):
	var node = get_parent()

	while node:
		if node is SalaBase:
			node.trocar_sala.emit(Constants.UID_CENAS[cena_destino], spawn_destino)
			return
		node = node.get_parent()


func _highlight(value: float, componente: Node2D):
	var tween = create_tween().set_parallel()
	
	for child in componente.get_children():
		tween.tween_property(child, "modulate:a", value, 0.3)\
			.set_trans(Tween.TRANS_SINE)\
			.set_ease(Tween.EASE_OUT)
