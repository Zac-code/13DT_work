extends CanvasLayer

@onready var pause_panel: Control = $PausePanel


func _ready() -> void:
	# Allow this script and pause menu to work while the game is paused.
	process_mode = Node.PROCESS_MODE_ALWAYS
	pause_panel.hide()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		toggle_pause()


func toggle_pause() -> void:
	var is_paused := not get_tree().paused
	get_tree().paused = is_paused
	pause_panel.visible = is_paused
