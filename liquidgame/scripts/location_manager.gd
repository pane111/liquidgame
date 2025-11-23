extends Node

var locations = {
	"entrance_hall": "uid://d0e0mekr4kpgs",
	"office" : "uid://2m4mvq03m225",
	"boss_office" : "uid://dwp8cx2ei2dgj",
	"staircase" : "uid://brk45c6acql25",
	"basement_hallway" : "uid://1airqduoass5",
	"cooling_room" : "uid://csp3070m2ok0",
	"fabricator_room" : "uid://cxlpm3gdlhi18",
	"roof" : "uid://cxa6uqhmdl5of",
	"break_room" : "uid://d3v22pgllbtmu",
	"test" : "uid://d3v22pgllbtmu",
}

func get_area(name: String):
	var scene = load(locations[name])
	return scene
