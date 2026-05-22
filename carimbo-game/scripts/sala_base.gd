extends Node
class_name SalaBase

@warning_ignore("unused_signal")
signal trocar_sala(scene_path: String, spawn_id: String)

func on_enter():
	pass
	
func on_exit():
	pass
	
func get_spawn(spawn_id: String) -> Node2D:
	var node = get_node_or_null("SpawnPoints/" + spawn_id)
	return node
