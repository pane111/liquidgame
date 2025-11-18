extends "res://Assets/Scenes/System/interactable.gd"

@export_file("*.tscn") var _goto: String

func _on_interact():
	get_node("/root/MainGame").load_new_area(load(_goto))
	
	
