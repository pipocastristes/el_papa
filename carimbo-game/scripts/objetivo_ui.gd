extends CanvasLayer

@onready var objetivo_label: Label = $MarginContainer/VBoxContainer/HBoxContainer/ObjetivoLabel

func _ready() -> void:
	GameManager.objetivo_atualizado.connect(_objetivo_atualizado)
	
func _objetivo_atualizado(texto: String):
	var tween = create_tween()
	tween.tween_property(objetivo_label, "modulate:a", 0.0, 0.2)
	tween.tween_callback(func():
		objetivo_label.text = texto
	)
	tween.tween_property(objetivo_label, "modulate:a", 1.0, 0.2)
