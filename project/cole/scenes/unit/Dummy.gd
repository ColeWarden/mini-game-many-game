extends Unit
class_name Dummy


func play_turn()-> void:
	$Label.text = "My turn!"
	yield(get_tree().create_timer(2.0), "timeout")
	$Label.text = "Not my turn!"
	set_moves_left(0)
