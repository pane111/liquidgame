extends PanelContainer

var e_item: Evidence

func set_item(i: Evidence):
	e_item = i
	$HBoxContainer/TextureRect.texture = i.e_sprite
	$HBoxContainer/Label.text = i.e_name


func _on_mouse_entered() -> void:
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
	



func _on_mouse_exited() -> void:
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
