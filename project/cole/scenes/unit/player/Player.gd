extends Unit

onready var flashlight: FlashLight = $Flashlight

func _ready() -> void:
	connect("move_to_tile", flashlight, "_update_tile")
	set_tile_position(Vector2(3,3))
	
func _process(delta: float) -> void:
	._process(delta)
	move(_get_input())

func _get_input()-> Vector2:
	var x: int = int(Input.is_action_just_pressed("d")) - int(Input.is_action_just_pressed("a"))
	var y: int = int(Input.is_action_just_pressed("s")) - int(Input.is_action_just_pressed("w"))
	return Vector2(x, y)
