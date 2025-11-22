extends Node

var locations = {
	"_entrance_hall": "res://assets/scenes/areas/mainHall.tscn",
	"_office" : "res://assets/scenes/areas/office.tscn",
	"_boss_office" : "res://assets/scenes/areas/bossOffice.tscn",
	"_staircase" : "res://assets/scenes/areas/stairway.tscn",
	"_basement_hallway" : "res://assets/scenes/areas/basement_hallway.tscn",
	"_cooling_room" : "res://assets/scenes/areas/cooling_room.tscn",
	"_fabricator_room" : "res://assets/scenes/areas/fabricator_room.tscn",
	"_roof" : "res://assets/scenes/areas/roof.tscn",
	"_break_room" : "res://assets/scenes/areas/test_room.tscn",
	"_test" : "res://assets/scenes/areas/test_room.tscn",
}

var current_area
var prev_area
var main_game_node
var player
var inter_obj
var cur_char
signal finished_dialogue
signal finished_dialogue_hide
signal presented
var hide_after=false
var in_dialogue=false

var ev_open=false
var can_open_ev=true
var cur_ev

@export var voice_pitch_lower = 0.2
@export var voice_pitch_higher = 0.1
@export var ev_item_scene: PackedScene
@export var player_voice: AudioStream

var queued_char
var queued_dia
var queued=false

func _ready() -> void:
	main_game_node = get_node("/root/MainGame")
	player = $Player
	$VoicePlayer.stream = player_voice
	load_new_area(load(locations["_boss_office"]),false)
	set_evidence()
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("rclick") && can_open_ev:
		toggle_ev()
func set_cur_ev(val: Evidence):
	cur_ev = val
	
func dialogue_anim(dia: DialogueResource, char: Character = null):
	hide_after=false
	if char != null:
		player.can_look=false
		$CanvasLayer/DialoguePanel.show()
		cur_char = char
		
		$VoicePlayer.stream = char.voice
		set_normal_expression()
		in_dialogue=true
		$CanvasLayer/DialoguePanel/CharSprite/Shading.self_modulate = char.color
		if !queued:
			$CanvasLayer/DialoguePanel/DialogueAnim.current_animation = "dialogue_start"
		else:
			queued=false
			$CanvasLayer/DialoguePanel/DialogueAnim.current_animation = "fade_char_in"
		await $CanvasLayer/DialoguePanel/DialogueAnim.animation_finished
		var balloon = DialogueManager.show_example_dialogue_balloon(dia,"start")
		await DialogueManager.dialogue_ended
		if ev_open:
			close_evidence_menu()
			await $CanvasLayer/DialoguePanel/DialogueAnim.animation_finished
		if !queued:
			$CanvasLayer/DialoguePanel/DialogueAnim.current_animation = "dialogue_end"
			await $CanvasLayer/DialoguePanel/DialogueAnim.animation_finished
			$CanvasLayer/DialoguePanel.hide()
			player.can_look=true
			finished_dialogue.emit()
			in_dialogue=false
			$VoicePlayer.stream = player_voice
		else:
			$CanvasLayer/DialoguePanel/DialogueAnim.current_animation = "fade_char_out"
			await $CanvasLayer/DialoguePanel/DialogueAnim.animation_finished
			cur_char = queued_char
			dialogue_anim(queued_dia,queued_char)
	else:
		DialogueManager.show_example_dialogue_balloon(dia,"start")
		in_dialogue=true
		await DialogueManager.dialogue_ended
		in_dialogue=false
		if queued:
			queued=false
			cur_char = queued_char
			dialogue_anim(queued_dia,queued_char)
func play_voice():
	var random_pitch = randf_range(1-voice_pitch_lower,1+voice_pitch_higher)
	$VoicePlayer.pitch_scale = random_pitch
	$VoicePlayer.play()
func set_player_voice():
	$VoicePlayer.stream = player_voice
	
func link_dialogue(dia: String, char: String):
	queued_dia = load(dia)
	queued_char = load(char)
	queued=true
	
	
func ev_detail(evidence: Evidence):
	set_cur_ev(evidence)
	$CanvasLayer/DialoguePanel/EvLayer/ItemDetails/VBoxContainer/HBoxContainer/ItemSprite.texture = evidence.e_sprite
	$CanvasLayer/DialoguePanel/EvLayer/ItemDetails/VBoxContainer/HBoxContainer/ItemName.text = evidence.e_name
	$CanvasLayer/DialoguePanel/EvLayer/ItemDetails/VBoxContainer/ItemDesc.text = evidence.e_desc
	$CanvasLayer/DialoguePanel/EvLayer/ItemDetails.show()
	if in_dialogue:
		$CanvasLayer/DialoguePanel/EvLayer/PresentButton.show()

func set_normal_expression():
	$CanvasLayer/DialoguePanel/CharSprite/Outline.texture = cur_char.normal_outline
	$CanvasLayer/DialoguePanel/CharSprite/Color.texture = cur_char.normal_color
	$CanvasLayer/DialoguePanel/CharSprite/Shading.texture = cur_char.normal_shading

func open_evidence_menu():
	$CanvasLayer/DialoguePanel/DialogueAnim.current_animation = "evidence_on"
	$CanvasLayer/DialoguePanel/EvLayer/EvidenceList.show()
	ev_open=true
	player.can_look=false

func close_evidence_menu():
	$CanvasLayer/DialoguePanel/EvLayer/ItemDetails.hide()
	$CanvasLayer/DialoguePanel/EvLayer/PresentButton.hide()
	$CanvasLayer/DialoguePanel/DialogueAnim.current_animation = "evidence_off"
	await $CanvasLayer/DialoguePanel/DialogueAnim.animation_finished
	$CanvasLayer/DialoguePanel/EvLayer/EvidenceList.hide()
	ev_open=false
	player.can_look=true

func toggle_ev():
	if ev_open:
		close_evidence_menu()
	else:
		open_evidence_menu()


func set_evidence():
	for c in $CanvasLayer/DialoguePanel/EvLayer/EvidenceList/EvidenceItems.get_children():
		$CanvasLayer/DialoguePanel/EvLayer/EvidenceList/EvidenceItems.remove_child(c)
		c.queue_free()
	for key in FlagManager.evidence:
		var item = FlagManager.evidence[key]
		var new_listitem = ev_item_scene.instantiate()
		new_listitem.set_item(item)
		$CanvasLayer/DialoguePanel/EvLayer/EvidenceList/EvidenceItems.add_child(new_listitem)
	
func set_surprised_expression(animate = true):
	if animate:
		$CanvasLayer/DialoguePanel/DialogueAnim.current_animation = "surprised"
	$CanvasLayer/DialoguePanel/CharSprite/Outline.texture = cur_char.surprised_outline
	$CanvasLayer/DialoguePanel/CharSprite/Color.texture = cur_char.surprised_color
	$CanvasLayer/DialoguePanel/CharSprite/Shading.texture = cur_char.surprised_shading
	
func set_angry_expression(animate = true):
	if animate:
		$CanvasLayer/DialoguePanel/DialogueAnim.current_animation = "surprised"
	$CanvasLayer/DialoguePanel/CharSprite/Outline.texture = cur_char.angry_outline
	$CanvasLayer/DialoguePanel/CharSprite/Color.texture = cur_char.angry_color
	$CanvasLayer/DialoguePanel/CharSprite/Shading.texture = cur_char.angry_shading

func show_objects():
	current_area.show_all()
func hide_objects():
	current_area.hide_all()

func hide_after_dialogue():
	hide_after = true
	
func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("click"):
		$CanvasLayer/RClickMenu.hide()
		if inter_obj != null:
			inter_obj._on_interact()
			AudioManager._play_sound("clickSuccess")
		else:
			print_debug("You clicked on nothing")
			AudioManager._play_sound("clickFail")
	if Input.is_action_just_pressed("rclick"):
		$CanvasLayer/RClickMenu.position = get_viewport().get_mouse_position()
		$CanvasLayer/RClickMenu.visible = !$CanvasLayer/RClickMenu.visible
	if Input.is_action_just_pressed("number"):
		match event.keycode:
			KEY_0:
				load_new_area(load(locations["_test"]))
			KEY_1:
				load_new_area(load(locations["_entrance_hall"]))
			KEY_2:
				load_new_area(load(locations["_office"]))
			KEY_3:
				load_new_area(load(locations["_boss_office"]))
			KEY_4:
				load_new_area(load(locations["_staircase"]))
			KEY_5:
				load_new_area(load(locations["_basement_hallway"]))
			KEY_6:
				load_new_area(load(locations["_cooling_room"]))
			KEY_7:
				load_new_area(load(locations["_fabricator_room"]))
			KEY_8:
				load_new_area(load(locations["_roof"]))
			KEY_9:
				load_new_area(load(locations["_break_room"]))
func load_path(area: String, fade=true):
	load_new_area(load(area),fade)

func load_new_area(area: PackedScene, fade = true):
	if area != null:
		if fade:
			$CanvasLayer/FadeAnim.current_animation = "fade_black_in"
			player.can_look=false
			await $CanvasLayer/FadeAnim.animation_finished
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
		if fade:
			$CanvasLayer/FadeAnim.current_animation = "fade_black_out"
			await $CanvasLayer/FadeAnim.animation_finished
			player.can_look=true

func set_char_voice(name):
	$VoicePlayer.stream = FlagManager.characters[name].voice

func _on_go_back_button_down() -> void:
	$CanvasLayer/RClickMenu.hide()
	if prev_area != "" || prev_area!=null:
		load_new_area(load(prev_area))
func shock_effect():
	$CanvasLayer/FadeAnim.current_animation="flash_white"
	AudioManager._play_sound("crash")
	AudioManager._switch_music("caught")
func flash():
	$CanvasLayer/FadeAnim.current_animation="flash_white"
	AudioManager._play_sound("crash")

func blackout():
	$CanvasLayer/Fade.self_modulate = Color.BLACK
func restore_light():
	$CanvasLayer/Fade.self_modulate = Color.TRANSPARENT

func regain():
	$CanvasLayer/FadeAnim.current_animation="flash_white"
	AudioManager._play_sound("regain")
	AudioManager._switch_music("main")

func _on_present_button_pressed() -> void:
	if cur_ev.e_name == FlagManager.weak_point:
		print_debug("Picked correct evidence")
		FlagManager.caught=true
		close_evidence_menu()
		await $CanvasLayer/DialoguePanel/DialogueAnim.animation_finished
		presented.emit()
	else:
		print_debug("Wrong evidence/no weak point")
		FlagManager.caught=false
		close_evidence_menu()
		await $CanvasLayer/DialoguePanel/DialogueAnim.animation_finished
		presented.emit()
	
