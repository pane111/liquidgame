extends "res://Assets/Scenes/System/interactable.gd"

@export var dialogue: DialogueResource
@export var hovering = true
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if !hovering:
		$AnimationPlayer.stop()
func _on_interact():
	get_node("/root/MainGame").dialogue_anim(dialogue)
	if hovering:
		$AnimationPlayer.current_animation = "clicked"
		await $AnimationPlayer.animation_finished
		$AnimationPlayer.current_animation = "hover"
