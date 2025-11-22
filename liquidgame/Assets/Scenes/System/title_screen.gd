extends Node2D

var main_scene = "res://Assets/Scenes/System/main_game.tscn"
func _on_start_btn_pressed() -> void:
	get_tree().change_scene_to_file(main_scene)
