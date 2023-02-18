extends Unit

onready var flashlight: FlashLight = $Flashlight
onready var gui: PlayerGui = $Gui
#var freeplay: bool = false

func cycle_flashlight_mode(cycle: bool)-> void:
	if !cycle:
		return
	var mode: int = flashlight.get_mode()
	mode += 1
	mode = mode % FlashLight.MODE.limit
	flashlight.set_mode(mode)

func _ready() -> void:
	._ready()
	var _err = connect("move_to_tile", flashlight, "set_tile_position")
	_err = connect("look_to_direction", flashlight, "set_look_direction")
	_err = connect("moves_left", self, "_update_gui_moves")
	flashlight.set_tile_size(3)
	set_starting_moves(10)

func _out_of_moves()-> void:
	_update_gui_waiting()

func _update_gui_waiting()-> void:
	gui.set_state_waiting()

func _update_gui_moves(_moves_left: int)-> void:
	gui.set_state_moves(_moves_left)


func _process(delta: float) -> void:
	._process(delta)
	move(_get_input())
	look(_get_look_input())
	cycle_flashlight_mode(_get_cycle_input())

func _get_input()-> Vector2:
	var x: int = int(Input.is_action_just_pressed("d")) - int(Input.is_action_just_pressed("a"))
	var y: int = int(Input.is_action_just_pressed("s")) - int(Input.is_action_just_pressed("w"))
	return Vector2(x, y)

func _get_look_input()-> Vector2:
	var x: int = int(Input.is_action_just_pressed("ui_right")) - int(Input.is_action_just_pressed("ui_left"))
	var y: int = int(Input.is_action_just_pressed("ui_down")) - int(Input.is_action_just_pressed("ui_up"))
	return Vector2(x, y)

func _get_cycle_input()-> bool:
	return Input.is_action_just_pressed("shift")
