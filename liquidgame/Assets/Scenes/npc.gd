extends "res://Assets/Scenes/System/interactable.gd"

@export var dialogue: DialogueResource
@export var character: Character
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Outline.texture = character.normal_outline
	$Color.texture = character.normal_color
	$Shading.texture = character.normal_shading
	$Shading.modulate = Color("ee82ee")
	
func _on_interact():
	get_node("/root/MainGame").dialogue_anim(dialogue,character)
	$AnimationPlayer.current_animation="disappear"
	await get_node("/root/MainGame").finished_dialogue
	$AnimationPlayer.current_animation="appear"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
