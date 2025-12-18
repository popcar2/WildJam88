@warning_ignore("missing_tool")
extends SimpleState

@onready var player: Player = state_bot.puppet
@onready var animated_sprite: AnimatedSprite2D = %AnimatedSprite2D

var is_jump_released: float

func _enter_state(_last_state: SimpleState) -> void:
	%AnimatedSprite2D.play("jump")
	is_jump_released = false


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
	if not is_jump_released and not Input.is_action_pressed("jump") and player.velocity.y < 0:
		player.velocity.y /= 2
		is_jump_released = true
	
	var input_axis: float = player.get_input_axis()
	var target_acceleration: float = player.ACCELERATION * delta
	if sign(input_axis) == -sign(player.velocity.x):
		target_acceleration *= 2
	
	player.velocity.x = move_toward(player.velocity.x, input_axis * player.MAX_MOVE_SPEED, target_acceleration)



func handle_transitions():
	if player.is_on_floor():
		if player.get_input_axis():
			state_bot.switch_to_state("Walking")
			player.play_landing_animation()
		else:
			state_bot.switch_to_state("Idle")
			player.play_landing_animation()
	elif Input.is_action_just_pressed("dash"):
		state_bot.switch_to_state("Dash")
