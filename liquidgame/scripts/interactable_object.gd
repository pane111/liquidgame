extends "res://Assets/Scenes/System/interactable.gd"

@export var dialogue: DialogueResource
# Called when the node enters the scene tree for the first time.
func _on_interact():
	get_node("/root/MainGame").dialogue_anim(dialogue)
	$AnimationPlayer.current_animation = "clicked"
	await $AnimationPlayer.animation_finished
	$AnimationPlayer.current_animation = "hover"
