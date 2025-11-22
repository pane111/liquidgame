extends "res://Assets/Scenes/System/interactable.gd"

@export var dialogue: DialogueResource
@export var hovering = true
@export var destroy = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if !hovering && $AnimationPlayer!=null:
		$AnimationPlayer.stop()
func _on_interact():
	get_node("/root/MainGame").dialogue_anim(dialogue)
	if hovering:
		$AnimationPlayer.current_animation = "clicked"
		await $AnimationPlayer.animation_finished
		$AnimationPlayer.current_animation = "hover"
	if destroy:
		queue_free()
