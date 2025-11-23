extends "res://Assets/Scenes/System/interactable.gd"

@export var dialogue: DialogueResource
@export var character: Character
@export var req_flag: String
@export var flag_is_string = false # If TRUE, the flag returns a string, eg flag "last_room" = "office", if FALSE, check an int, eg "completed_tutorial" = 1
@export var flag_val_int_min: int
@export var flag_val_int_max: int
@export var flag_val_string: String
@export var clickable = true
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var showchar = true
	if req_flag != "" && req_flag!= null: # Check if the NPC has a required flag
		if flag_is_string && FlagManager.get_str(req_flag) != flag_val_string: # If flag is a STRING, and the flag in FlagManager does not equal the required value, hide character
			showchar=false
		if !flag_is_string && (FlagManager.get_int(req_flag) < flag_val_int_min || FlagManager.get_int(req_flag) > flag_val_int_max): # If flag is an INT, and the flag in FlagManager is not in the range hide character
			showchar=false
	if !showchar:
		$Area3D.input_ray_pickable = false
		$Outline.hide()
		$Color.hide()
		$Shading.hide()
	else:
		$Outline.texture = character.normal_outline
		$Color.texture = character.normal_color
		$Shading.texture = character.normal_shading
		$Shading.modulate = Color("f4b3f4")
		$Outline.billboard = FlagManager.billboarding
		$Color.billboard = FlagManager.billboarding
		$Shading.billboard = FlagManager.billboarding
	
	# $Color.material_overlay = character.material
	
func _on_interact():
	if clickable:
		clickable=false
		get_node("/root/MainGame").dialogue_anim(dialogue,character)
		$AnimationPlayer.current_animation="disappear"
		await get_node("/root/MainGame").finished_dialogue
		if get_node("/root/MainGame").hide_after:
			$Area3D.input_ray_pickable = false
		else:
			$AnimationPlayer.current_animation="appear"

func disappear():
	$Area3D.input_ray_pickable = false
	$AnimationPlayer.current_animation="disappear"

func appear():
	$AnimationPlayer.current_animation="appear"
	await $AnimationPlayer.animation_finished
	$Area3D.input_ray_pickable = true
	clickable=true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
