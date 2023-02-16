extends CanvasLayer
class_name PlayerGui

enum STATE {
	UNDEFINED = -1,
	MOVE = 0,
	WAIT = 1,
	FREEPLAY = 2,
}
onready var stateLabel: Label = $Control/VBox/State
onready var tween: Tween = $Tween
var next_text: String = ""
var instant_mode: bool = false
var old_state: int = 100
var state: int = STATE.UNDEFINED

func _set_next_text(text: String)-> void:
	next_text = text

func set_state_moves(moves_left: int)-> void:
	state = STATE.MOVE
	_set_next_text("Moves left\n" + str(moves_left))
	change_states()

func set_state_free()-> void:
	state = STATE.FREEPLAY
	_set_next_text("Free Movement")
	change_states()

func set_state_waiting()-> void:
	state = STATE.WAIT
	_set_next_text("Waiting")
	change_states()

func change_states(instant: bool = instant_mode)-> void:
	if instant:
		_show_next_text()
	else:
		if (state != old_state):
			old_state = state
			tween_alpha(0.0)
		else:
			_show_next_text()

func _show_next_text()-> void:
	stateLabel.text = next_text
	next_text = ""

func tween_alpha(mod_a: float)-> void:
	tween.stop_all()
	var dur: float = 0.5
	var trans: int = Tween.TRANS_CUBIC
	var eas: int = Tween.EASE_IN_OUT
	tween.interpolate_property(stateLabel, "modulate:a", null, mod_a, dur, trans, eas)
	tween.start()

func _tween_completed(object: Object, key: NodePath) -> void:
	if (key == ":modulate:a"):
		if object.modulate.a == 0.0:
			_show_next_text()
			tween_alpha(1.0)
