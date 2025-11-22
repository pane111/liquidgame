extends Node3D

@export var start_point: Node3D
@export var rotation_lim: Vector2
@export var area_name: String
@export_file("*.tscn") var _prev: String

@export var req_flag: String
@export var flag_is_string = false # If TRUE, the flag returns a string, eg flag "last_room" = "office", if FALSE, check an int, eg "completed_tutorial" = 1
@export var flag_val_int: int
@export var flag_val_string: String

@export var init_dialogue: DialogueResource
@export var init_char: Character

func _ready() -> void:
	var startdia = true
	if req_flag != "" && req_flag!= null: # Check if the NPC has a required flag
		if flag_is_string && FlagManager.get_str(req_flag) != flag_val_string: # If flag is a STRING, and the flag in FlagManager does not equal the required value, hide character
			startdia=false
		if !flag_is_string && FlagManager.get_int(req_flag) != flag_val_int: # If flag is an INT, and the flag in FlagManager does not equal the required value, hide character
			startdia=false
	if init_dialogue != null && startdia:
		get_node("/root/MainGame").cur_char = init_char
		get_node("/root/MainGame").dialogue_anim(init_dialogue, init_char)
