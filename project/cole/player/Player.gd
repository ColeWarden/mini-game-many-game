extends Node2D

# Test code
onready var spd: float = 10.0
func _input(event: InputEvent) -> void:
	if event.is_action("ui_down"):
		position.y += spd

# HERE
# Stuff
