@warning_ignore("missing_tool")
extends SimpleState

#@export var soft_max_bounce_height: float = -1200
@export var max_bounce_height: float = -1800

@onready var player: Player = state_bot.puppet
@onready var animated_sprite: AnimatedSprite2D = %AnimatedSprite2D

var tween: Tween

func _enter_state(last_state: SimpleState) -> void:
	var previous_velocity: float = last_state.biggest_velocity - 100
	player.play_jump_animation()
	$BounceCooldown.start()
	%BounceSFX.pitch_scale = randf_range(0.90, 1)
	%BounceSFX.play()
	
	if player.finished_initial_bounce == false:
		player.finished_initial_bounce = true
		player.velocity.y = clampf(-previous_velocity * 1.2, max_bounce_height, 0)
		
		# Breaks the soft max bounce height on really high jumps
		#if previous_velocity > 1200:
		#	var bonus_velocity: float = player.velocity.y - previous_velocity + 1200
		#	print(bonus_velocity)
		#	player.velocity.y = clampf(bonus_velocity, max_bounce_height, 0)
	else:
		player.velocity.y = clampf(-previous_velocity * 0.85, max_bounce_height / 2, 0)
	
	#print(previous_velocity, "\t", player.velocity.y)
	tween = create_tween()
	tween.set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(%AnimatedSprite2D, "rotation_degrees", 0, 2)


func _exit_state(_new_state: SimpleState) -> void:
	tween.kill()
	%AnimatedSprite2D.rotation_degrees = 0


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
	var target_acceleration: float = player.ACCELERATION * delta
	
	player.velocity.x = move_toward(player.velocity.x, input_axis * player.MAX_MOVE_SPEED, target_acceleration * 2)

func handle_transitions() -> void:
	if player.is_on_floor():
		if player.get_input_axis():
			state_bot.switch_to_state("Walking")
		else:
			state_bot.switch_to_state("Idle")
		player.play_landing_animation()
	elif Input.is_action_just_pressed("dash") and $BounceCooldown.is_stopped():
		state_bot.switch_to_state("Dash")
