@warning_ignore("missing_tool")
extends SimpleState

@onready var player: Player = state_bot.puppet
@onready var animated_sprite: AnimatedSprite2D = %AnimatedSprite2D

func _enter_state(_last_state: SimpleState) -> void:
	pass


func _exit_state(_new_state: SimpleState) -> void:
	pass


func _state_process(_delta: float) -> void:
	pass


func _state_physics_process(delta: float) -> void:
	handle_movement(delta)
	player.apply_gravity(delta)
	
	player.move_and_slide()
	handle_transitions()

func handle_movement(delta: float):
	player.velocity.x = move_toward(player.velocity.x, 0, player.ACCELERATION * delta)

func handle_transitions():
	if not player.is_on_floor():
		state_bot.switch_to_state("Airborne")
	elif player.get_input_axis():
		state_bot.switch_to_state("Walking")
	elif InputBuffer.is_action_buffered("jump"):
		InputBuffer.invalidate_buffer_action("jump")
		player.velocity.y = player.JUMP_VELOCITY
		state_bot.switch_to_state("Airborne")
