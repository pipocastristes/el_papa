extends Interagivel
class_name SceneTrigger

@onready var point_light_2d: PointLight2D = $PointLight2D

func _ready():
	super._ready()
	point_light_2d.energy = 0

func _on_body_entered(body):
	super._on_body_entered(body)

	if body.is_in_group("player"):
		var tween = create_tween()
		tween.tween_property(point_light_2d, "energy", 0.5, 0.2)

func _on_body_exited(body):
	super._on_body_exited(body)

	if body.is_in_group("player"):
		var tween = create_tween()
		tween.tween_property(point_light_2d, "energy", 0, 0.2)
		
func interagir(_player):
	if  GameManager.pode_levantar:
		DialogueManager.start_dialogue([
			{
				"text": "Não tem pra que voltar agora"
			}
		], false)
		
		return
	TransitionManager.change_scene(Constants.UID_SCENES[Constants.TELAS.DESK])
