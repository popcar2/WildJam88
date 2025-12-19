extends Node2D

@export var value = 0

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		Hud.add_coin(value);
		queue_free()
