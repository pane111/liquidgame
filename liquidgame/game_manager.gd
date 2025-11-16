extends Node

@export_file("*.tscn") var _default_area: String
var current_area
var main_game_node
var player
var inter_obj
var cur_char
func _ready() -> void:
	main_game_node = get_node("/root/MainGame")
	player = main_game_node.get_child(0)
	load_new_area(load(_default_area))
	
func dialogue_anim(dia: DialogueResource, char: Character):
	$DialoguePanel.show()
	cur_char = char
	
	$DialoguePanel/CharSprite/Shading.self_modulate = char.color
	$DialoguePanel/DialogueAnim.current_animation = "dialogue_start"
	await $DialoguePanel/DialogueAnim.animation_finished
	DialogueManager.show_example_dialogue_balloon(dia,"start")
	await DialogueManager.dialogue_ended
	$DialoguePanel/DialogueAnim.current_animation = "dialogue_end"
	await $DialoguePanel/DialogueAnim.animation_finished
	$DialoguePanel.hide()
	
func set_normal_expression():
	$DialoguePanel/CharSprite/Outline.texture = cur_char.normal_outline
	$DialoguePanel/CharSprite/Color.texture = cur_char.normal_color
	$DialoguePanel/CharSprite/Shading.texture = cur_char.normal_shading
	
func set_surprised_expression():
	$DialoguePanel/CharSprite/Outline.texture = cur_char.surprised_outline
	$DialoguePanel/CharSprite/Color.texture = cur_char.surprised_color
	$DialoguePanel/CharSprite/Shading.texture = cur_char.surprised_shading
	
func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("click"):
		if inter_obj != null:
			inter_obj._on_interact()
		else:
			print_debug("You clicked on nothing")
	
func load_new_area(area: PackedScene):
	var new_area = area.instantiate()
	if current_area != null:
		current_area.queue_free()
	add_child(new_area)
	current_area = new_area
	player.global_position = current_area.start_point.position
	player.rotation = current_area.start_point.rotation
