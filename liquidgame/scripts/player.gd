extends Camera3D

@export var panning_speed = 1.0
@export var panning_percentage = 0.15
@export var panning_limit = Vector2(30,30)
var panvec
func _ready() -> void:
	print_debug("Player initialized")

func _unhandled_input(event: InputEvent) -> void:
	var mouse_pos = get_viewport().get_mouse_position()
	var screen = get_viewport().size
	if mouse_pos.x < screen.x * panning_percentage:
		panvec.y = 1
	elif mouse_pos.x > screen.x * (1-panning_percentage):
		panvec.y = -1
	elif mouse_pos.y < screen.y * panning_percentage:
		panvec.x = 1
	elif mouse_pos.y > screen.y * (1-panning_percentage):
		panvec.x = -1
	else:
		panvec = Vector3.ZERO

func _process(delta: float) -> void:
	rotation += panvec * panning_speed * delta
	
