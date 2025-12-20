extends Node2D

@export var value = 0

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		Hud.add_coin(value)
		$Area2D.set_deferred("monitoring", false)
		$AudioStreamPlayer2D.pitch_scale = randf_range(0.95, 1.05)
		$AudioStreamPlayer2D.play()
		play_collect_animation()

func play_collect_animation():
	var tween: Tween = create_tween()
	tween.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.set_parallel()
	
	tween.tween_property($AnimatedSprite2D, "scale", Vector2(1, 1.5), 0.3)
	tween.tween_property(self, "modulate", Color(10, 10, 10), 0.3)
	tween.tween_property(self, "modulate:a", 0, 0.5)
