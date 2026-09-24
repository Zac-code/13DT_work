extends Node2D
@onready var pause_menu = "res://assets/pause.tscn"
var paused = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if input.is_action_just_pressed("pause"):
		PauseMenu()

func pausemenu():
	if paused
		pause_menu.hide()
		Engine.time_scale = 1
	else:
		pause_menu.show()
		Engine.time_scale = 0

	paused = !paused
