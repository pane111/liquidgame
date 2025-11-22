extends Camera3D

@export var panning_speed = Vector2(5.0,1.0)
@export var panning_percentage = 0.2
@export var panning_limit = Vector2(30,30)
@export var easing = 3.0
var can_look = true
var init_rot= Vector3(0,0,0)
var panvec=Vector3.ZERO
var pan_mult = 1.0
func _ready() -> void:
	SuperManager.player = self
	print_debug("Player initialized")
	

func _unhandled_input(event: InputEvent) -> void:
	var mouse_pos = get_viewport().get_mouse_position()
	var screen = get_viewport().get_visible_rect().size
	var center = screen * 0.5
	if mouse_pos.x < screen.x * panning_percentage:
		panvec.y = 1
	elif mouse_pos.x > screen.x * (1-panning_percentage):
		panvec.y = -1
	else:
		panvec.y = 0
	
	if mouse_pos.y < screen.y * panning_percentage:
		panvec.x = 1
	elif mouse_pos.y > screen.y * (1-panning_percentage):
		panvec.x = -1
	else:
		panvec.x = 0
		
	
	


func _process(delta: float) -> void:
	if can_look && !get_parent().in_dialogue:
		var x_pan = panvec.normalized().x * panning_speed.x * delta * pan_mult
		rotation_degrees.x = lerp(rotation_degrees.x,rotation_degrees.x+x_pan,delta * easing)
		rotation_degrees.x = clamp(rotation_degrees.x + x_pan,init_rot.x,init_rot.x + panning_limit.x)
		var y_pan = panvec.normalized().y * panning_speed.y * delta * pan_mult
		rotation_degrees.y = lerp(rotation_degrees.y,rotation_degrees.y+y_pan,delta * easing)
		rotation_degrees.y = clamp(rotation_degrees.y,init_rot.y - panning_limit.y,init_rot.y + panning_limit.y)
	
	
