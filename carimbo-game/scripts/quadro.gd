extends Interagivel
class_name Quadro

@onready var color_rect: ColorRect = $ColorRect

func _ready():
	super._ready()
	
	if GameManager.el_papa_foto:
		monitoring = false
	
	color_rect.modulate.a = 0
	
func _on_body_entered(body):
	if GameManager.el_papa_foto:
		return
	
	super._on_body_entered(body)
	
	if body.is_in_group("player"):
		var tween = create_tween()
		tween.tween_property(color_rect, "modulate:a", 0.1, 0.3)
		
func _on_body_exited(body):
	super._on_body_exited(body)
	
	if body.is_in_group("player"):
		var tween = create_tween()
		tween.tween_property(color_rect, "modulate:a", 0, 0.3)
		
func interagir(_player):
	monitoring = false
	GameManager.el_papa_foto = true
