extends Node2D
var  current_area: Node3D
var  player: Camera3D

func reset_player_pos():
		player.global_position = current_area.start_point.position
		player.rotation_degrees = current_area.start_point.rotation_degrees
		player.init_rot = current_area.start_point.rotation_degrees
		player.panning_limit = current_area.rotation_lim
