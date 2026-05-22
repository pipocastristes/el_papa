extends Interagivel
class_name Porta

@export var cena_destino: Constants.CENAS_ORDENADAS
@export var spawn_destino: String
@export var light_max := 0.5
@export var min_game_level := 1

@onready var point_light_2d: PointLight2D = $PointLight2D

func _ready():
	super._ready()
	point_light_2d.energy = 0


func _on_body_entered(body):
	super._on_body_entered(body)

	if body.is_in_group("player"):
		var tween = create_tween()
		tween.tween_property(point_light_2d, "energy", light_max, 0.2)


func _on_body_exited(body):
	super._on_body_exited(body)

	if body.is_in_group("player"):
		var tween = create_tween()
		tween.tween_property(point_light_2d, "energy", 0, 0.2)


func interagir(_player):

	if GameManager.game_level < min_game_level:
		return

	var node = get_parent()

	while node:
		if node is SalaBase:
			node.trocar_sala.emit(Constants.UID_CENAS[cena_destino], spawn_destino)
			return
		node = node.get_parent()
