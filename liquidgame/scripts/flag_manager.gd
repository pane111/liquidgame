extends Node


var int_flags = {
	"test_int": 1
}

var str_flags = {
	"test_str": "test"
}

func set_int(name,val):
	int_flags[name]=val
	
func set_str(name,val):
	str_flags[name]=val
	
func get_int(name):
	return int_flags[name]
	
func get_str(name):
	return str_flags[name]
