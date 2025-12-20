@warning_ignore("missing_tool")
extends SimpleState

@onready var player: Player = state_bot.puppet
@onready var animated_sprite: AnimatedSprite2D = %AnimatedSprite2D

var tween: Tween

func _enter_state(_last_state: SimpleState) -> void:
	%AnimatedSprite2D.play("walk")
	play_walk_animation()
	player.finished_initial_bounce = false


func _exit_state(_new_state: SimpleState) -> void:
	if tween:
		tween.kill()
	
	%AnimatedSprite2D.scale = Vector2(1, 1)


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
	if sign(input_axis) == -sign(player.velocity.x):
		target_acceleration *= 2
	
	player.velocity.x = move_toward(player.velocity.x, input_axis * player.MAX_MOVE_SPEED, target_acceleration)


func handle_transitions():
	if not player.is_on_floor():
		state_bot.switch_to_state("Airborne")
	elif player.velocity.x == 0 and not player.get_input_axis():
		state_bot.switch_to_state("Idle")
	elif InputBuffer.is_action_buffered("jump"):
		player.jump()
		state_bot.switch_to_state("Airborne")

func play_walk_animation():
	reset_tween()
	tween.set_loops()
	tween.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(%AnimatedSprite2D, "scale:y", 0.96, 0.2)
	tween.tween_property(%AnimatedSprite2D, "scale:x", 1.08, 0.2)
	
	tween.chain()
	tween.tween_property(%AnimatedSprite2D, "scale:y", 1, 0.15)
	tween.tween_property(%AnimatedSprite2D, "scale:x", 1, 0.15)

func reset_tween():
	if tween:
		tween.kill()
	
	tween = create_tween()
	tween.set_parallel()
