extends Area2D

@export var next_level : String

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		SceneManager.load_scene(next_level)
