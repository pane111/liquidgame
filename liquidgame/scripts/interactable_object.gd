extends "res://Assets/Scenes/System/interactable.gd"

@export var image: Texture2D
@export var dialogue: DialogueResource
@export var hovering = true
@export var destroy = false
var clickable=true
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Sprite3D.texture = image
	if !hovering && $AnimationPlayer!=null:
		$AnimationPlayer.stop()
func _on_interact():
	if clickable:
		clickable=false
		get_node("/root/MainGame").dialogue_anim(dialogue)
		if hovering:
			$AnimationPlayer.current_animation = "clicked"
			await $AnimationPlayer.animation_finished
			$AnimationPlayer.current_animation = "hover"
		if destroy:
			queue_free()
		await DialogueManager.dialogue_ended
		clickable=true
