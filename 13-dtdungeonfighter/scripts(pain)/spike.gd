extends Area2D

const PLAYER_GROUP := "player"


func _on_body_entered(body: Node2D) -> void:
	print("called")
	if body in get_tree().get_nodes_in_group(PLAYER_GROUP):
		print("true")
		body.hit()
