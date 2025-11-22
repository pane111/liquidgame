extends "res://Assets/Scenes/System/interactable.gd"

@export var isLocked: bool = false
@export var dialogue: DialogueResource
@export var req_flag: String
@export var flag_is_string = false # If TRUE, the flag returns a string, eg flag "last_room" = "office", if FALSE, check an int, eg "completed_tutorial" = 1
@export var flag_val_int_min: int
@export var flag_val_int_max: int
@export var flag_val_string: String


@export_file("*.tscn") var _goto: String

func _on_interact():
	
	if req_flag != "" && req_flag != null: # Check if the NPC has a required flag
		if flag_is_string && FlagManager.get_str(req_flag) != flag_val_string: # If flag is a STRING, and the flag in FlagManager does not equal the required value, hide character
			isLocked=true
		else:
			isLocked=false
		if !flag_is_string && (FlagManager.get_int(req_flag) < flag_val_int_min || FlagManager.get_int(req_flag) > flag_val_int_max): # If flag is an INT, and the flag in FlagManager is not in the range hide character
			isLocked=true
		else:
			isLocked=false
	
	
	if !isLocked:
		get_node("/root/MainGame").load_new_area(load(_goto))
	else:
		get_node("/root/MainGame").dialogue_anim(dialogue)
	
	
