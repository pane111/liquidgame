extends "res://Assets/Scenes/System/interactable.gd"

@export var dialogue: DialogueResource
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _on_interact():
	get_node("/root/MainGame").dialogue_anim(dialogue)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
