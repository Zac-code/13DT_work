extends Area2D

const LEVEL2_SCENE := "res://13-dtdungeonfighter/scenes(maps n stuff)/level2.tscn"

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	# Only the player should activate the portal.
	if body.name == "player" or body.is_in_group("player"):
		get_tree().call_deferred("change_scene_to_file")
