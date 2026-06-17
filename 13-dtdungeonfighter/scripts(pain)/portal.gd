extends Area2D

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	get_tree().change_scene_to_file("res://13-dtdungeonfighter/scenes(maps n stuff)/level2.tscn")
