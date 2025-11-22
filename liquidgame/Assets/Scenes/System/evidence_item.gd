extends PanelContainer

var e_item: Evidence
var mouse_over = false

func set_item(i: Evidence):
	e_item = i
	$HBoxContainer/TextureRect.texture = i.e_sprite
	$HBoxContainer/Label.text = i.e_name
	

func _process(delta: float) -> void:
	if mouse_over && Input.is_action_just_pressed("click"):
		get_node("/root/MainGame").ev_detail(e_item)

func _on_mouse_entered() -> void:
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
	mouse_over=true
	



func _on_mouse_exited() -> void:
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
	mouse_over=false
