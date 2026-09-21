extends Area2D

const PLAYER_GROUP := "player"

@export var next_level : PackedScene


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group(PLAYER_GROUP):
		if next_level:
			get_tree().call_deferred("change_scene_to_packed", next_level)
