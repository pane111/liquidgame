extends Node3D


func _on_interact():
	print_debug("Clicked on interactable")
	
	


func _on_area_3d_mouse_entered() -> void:
	get_node("/root/MainGame").inter_obj = self
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)


func _on_area_3d_mouse_exited() -> void:
	if get_node("/root/MainGame").inter_obj == self:
		get_node("/root/MainGame").inter_obj = null
		Input.set_default_cursor_shape(Input.CURSOR_ARROW)
	
