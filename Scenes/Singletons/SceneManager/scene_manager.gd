extends CanvasLayer

var tween: Tween

func load_scene(next_scene: String = ""):
	%ColorRect.rotation_degrees = -90
	%ColorRect.pivot_offset.y = 810
	reset_tween()
	await tween.tween_property(%ColorRect, "rotation_degrees", 0, 0.6).finished
	
	if next_scene:
		get_tree().change_scene_to_file(next_scene)
	else:
		get_tree().reload_current_scene()
	
	Engine.time_scale = 1
	
	%ColorRect.pivot_offset.y = 0
	reset_tween()
	tween.tween_property(%ColorRect, "rotation_degrees", 95, 0.6)

func reset_tween():
	tween = create_tween().set_ignore_time_scale()
	tween.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
