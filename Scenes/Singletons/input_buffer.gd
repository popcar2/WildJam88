extends Node
## Buffers the input of specific actions such as jump and attack.

@export var buffer_window: float = 150
@export var actions_to_buffer: Array[String] = ["jump"]

var buffered_inputs: Dictionary = {}

func _ready():
	for action: String in actions_to_buffer:
		buffered_inputs[action] = 0

func _physics_process(_delta):
	for action: String in actions_to_buffer:
		if Input.is_action_just_pressed(action):
			buffer_input(action)

func buffer_input(action: String):
	buffered_inputs[action] = Time.get_ticks_msec()

## Returns true if an action was pressed within the buffer window.
## Invalidate your action when it works proper.
func is_action_buffered(action: String):
	if Time.get_ticks_msec() - buffered_inputs[action] <= buffer_window:
		return true
	
	return false

## Do this after an action pops off
func invalidate_buffer_action(action: String):
	buffered_inputs[action] = 0
