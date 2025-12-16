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
