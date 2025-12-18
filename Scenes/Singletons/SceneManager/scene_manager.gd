extends CanvasLayer

var tween: Tween

func reset_scene():
	Engine.time_scale = 1
	
	%ColorRect.rotation_degrees = -90
	reset_tween()
	await tween.tween_property(%ColorRect, "rotation_degrees", 0, 0.6).finished
	
	get_tree().reload_current_scene()
	
	reset_tween()
	tween.tween_property(%ColorRect, "rotation_degrees", 95, 0.6)

func reset_tween():
	tween = create_tween().set_ignore_time_scale()
	tween.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
