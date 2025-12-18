extends Area2D

@export var next_level : PackedScene
@onready var timer = $Timer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.queue_free()
		timer.start()


func _on_timer_timeout() -> void:
	get_tree().change_scene_to_packed(next_level)
