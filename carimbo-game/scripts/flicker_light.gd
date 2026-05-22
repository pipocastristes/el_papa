extends PointLight2D
class_name FlickerLight

@export var min_light := 0.1
@export var max_light := 1.0
@export var flicker_speed := 0.05
@export var min_timer := 20.0
@export var max_timer := 60.0

func _ready() -> void:
	randomize()
	_start_random_flicker()

func flicker():
	var tween = create_tween()
	var count = randi_range(2, 8)
	
	for i in count:
		var random_energy = randf_range(min_light, max_light - 0.5)
		
		tween.tween_property(
			self,
			"energy",
			random_energy,
			flicker_speed
		)
	
	tween.tween_property(
		self,
		"energy",
		max_light,
		flicker_speed
	)
	
func _start_random_flicker():
	while true:
		var wait_time = randf_range(min_timer, max_timer)
		await get_tree().create_timer(wait_time).timeout
		flicker()
