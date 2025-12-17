@warning_ignore("missing_tool")
extends SimpleState

@onready var player: Player = state_bot.puppet
@onready var animated_sprite: AnimatedSprite2D = %AnimatedSprite2D

func _enter_state(_last_state: SimpleState) -> void:
	%AnimatedSprite2D.play("walk")


func _exit_state(_new_state: SimpleState) -> void:
	pass


func _state_process(_delta: float) -> void:
	pass


func _state_physics_process(delta: float) -> void:
	handle_movement(delta)
	player.face_move_direction()
	player.apply_gravity(delta)
	
	player.move_and_slide()
	handle_transitions()


func handle_movement(delta: float):
	var input_axis: float = player.get_input_axis()
	
	player.velocity.x = move_toward(player.velocity.x, input_axis * player.MAX_MOVE_SPEED, player.ACCELERATION * delta)


func handle_transitions():
	if not player.is_on_floor():
		state_bot.switch_to_state("Airborne")
	elif player.velocity.x == 0 and not player.get_input_axis():
		state_bot.switch_to_state("Idle")
	elif InputBuffer.is_action_buffered("jump"):
		player.jump()
		state_bot.switch_to_state("Airborne")
