extends CanvasLayer

func _ready() -> void:
	visible = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		toggle_pause()

func toggle_pause() -> void:
	if visible:
		get_tree().paused = false
	else:
		get_tree().paused = true
	
	visible = not visible
	if visible:
		%ResumeButton.grab_focus()


func _on_sfx_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear_to_db(value))


func _on_music_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(value))


func _on_resume_button_pressed() -> void:
	toggle_pause()
