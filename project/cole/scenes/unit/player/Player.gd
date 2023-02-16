extends Unit

onready var flashlight: FlashLight = $Flashlight

func _ready() -> void:
	._ready()
	var _err = connect("move_to_tile", flashlight, "set_tile_position")
	_err = connect("look_to_direction", flashlight, "set_look_direction")


func _process(delta: float) -> void:
	._process(delta)
	move(_get_input())
	look(_get_look_input())


func _get_input()-> Vector2:
	var x: int = int(Input.is_action_just_pressed("d")) - int(Input.is_action_just_pressed("a"))
	var y: int = int(Input.is_action_just_pressed("s")) - int(Input.is_action_just_pressed("w"))
	return Vector2(x, y)

func _get_look_input()-> Vector2:
	var x: int = int(Input.is_action_just_pressed("ui_right")) - int(Input.is_action_just_pressed("ui_left"))
	var y: int = int(Input.is_action_just_pressed("ui_down")) - int(Input.is_action_just_pressed("ui_up"))
	return Vector2(x, y)