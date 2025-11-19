extends Node

@export_file("*.tscn") var _default_area: String
var current_area
var prev_area
var main_game_node
var player
var inter_obj
var cur_char
signal finished_dialogue
func _ready() -> void:
	main_game_node = get_node("/root/MainGame")
	player = $Player
	load_new_area(load(_default_area))
	
func dialogue_anim(dia: DialogueResource, char: Character = null):
	if char != null:
		player.can_look=false
		$CanvasLayer/DialoguePanel.show()
		cur_char = char
		set_normal_expression()
		$CanvasLayer/DialoguePanel/CharSprite/Shading.self_modulate = char.color
		$CanvasLayer/DialoguePanel/DialogueAnim.current_animation = "dialogue_start"
		await $CanvasLayer/DialoguePanel/DialogueAnim.animation_finished
		DialogueManager.show_example_dialogue_balloon(dia,"start")
		await DialogueManager.dialogue_ended
		$CanvasLayer/DialoguePanel/DialogueAnim.current_animation = "dialogue_end"
		await $CanvasLayer/DialoguePanel/DialogueAnim.animation_finished
		$CanvasLayer/DialoguePanel.hide()
		player.can_look=true
		finished_dialogue.emit()
	else:
		DialogueManager.show_example_dialogue_balloon(dia,"start")
		await DialogueManager.dialogue_ended
	
func set_normal_expression():
	$CanvasLayer/DialoguePanel/CharSprite/Outline.texture = cur_char.normal_outline
	$CanvasLayer/DialoguePanel/CharSprite/Color.texture = cur_char.normal_color
	$CanvasLayer/DialoguePanel/CharSprite/Shading.texture = cur_char.normal_shading
	
func set_surprised_expression():
	$CanvasLayer/DialoguePanel/CharSprite/Outline.texture = cur_char.surprised_outline
	$CanvasLayer/DialoguePanel/CharSprite/Color.texture = cur_char.surprised_color
	$CanvasLayer/DialoguePanel/CharSprite/Shading.texture = cur_char.surprised_shading
	
func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("click"):
		$CanvasLayer/RClickMenu.hide()
		if inter_obj != null:
			inter_obj._on_interact()
		else:
			print_debug("You clicked on nothing")
	if Input.is_action_just_pressed("rclick"):
		$CanvasLayer/RClickMenu.position = get_viewport().get_mouse_position()
		$CanvasLayer/RClickMenu.visible = !$CanvasLayer/RClickMenu.visible
	
func load_new_area(area: PackedScene):
	if area != null:
		var new_area = area.instantiate()
		if current_area != null:
			current_area.queue_free()
		add_child(new_area)
		current_area = new_area
		prev_area = current_area._prev
		$CanvasLayer/AreaLabel.text = current_area.area_name
		player.global_position = current_area.start_point.position
		player.rotation_degrees = current_area.start_point.rotation_degrees
		player.init_rot = current_area.start_point.rotation_degrees
		player.panning_limit = current_area.rotation_lim
	


func _on_go_back_button_down() -> void:
	$CanvasLayer/RClickMenu.hide()
	if prev_area != "" || prev_area!=null:
		load_new_area(load(prev_area))
