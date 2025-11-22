extends Node

@export var characters: Dictionary[String,Character]
@export var billboarding = true
@export var evidence: Dictionary[String,Evidence]
var weak_point: String
var caught=false
var int_flags = {
	"test_int": 1
}

var str_flags = {
	"test_str": "test"
}

func set_weak_point(val):
	weak_point = val
	caught=false

func add_evidence(name: String, ev: Evidence):
	evidence[name] = ev
	
func remove_evidence(name: String):
	evidence[name] = null

func char_name(name):
	var c = characters[name]
	var c_col = c.color
	var hex := "#%02x%02x%02x" % [int(c_col.r * 255), int(c_col.g * 255), int(c_col.b * 255)] 
	hex = hex.to_upper()
	var col_string = "[color="+str(hex)+"]"+c.c_name+"[/color]"
	print_debug("Character: " + col_string)
	return col_string

func set_int(name,val):
	int_flags[name]=val
	
func set_str(name,val):
	str_flags[name]=val
	
func get_int(name):
	return int_flags[name]
	
func get_str(name):
	return str_flags[name]
