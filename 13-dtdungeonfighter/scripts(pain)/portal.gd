extends Area2D

@export_file("*.tscn") var destination_scene: String = "res://level2.tscn"

func _on_portal_entered(body: Node2D) -> void:
	if body.name == "player":
		get_tree().change_scene_to_file(destination_scene)
