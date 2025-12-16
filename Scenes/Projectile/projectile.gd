extends Area2D
class_name Projectile

@export var speed : float

func _process(delta: float) -> void:
	move_local_x(speed * delta)


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.take_damage()
		queue_free()
	if body is TileMapLayer:
		queue_free()


func _on_timer_timeout() -> void:
	queue_free()
	
