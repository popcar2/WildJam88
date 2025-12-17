@warning_ignore("missing_tool")
extends SimpleState

@export var soft_max_bounce_height: float = -1000
@export var max_bounce_height: float = -1300

@onready var player: Player = state_bot.puppet
@onready var animated_sprite: AnimatedSprite2D = %AnimatedSprite2D

var tween: Tween

func _enter_state(last_state: SimpleState) -> void:
	var previous_velocity: float = last_state.biggest_velocity - 100
	player.play_jump_animation()
	player.velocity.y = clampf(-(previous_velocity * 1.2), soft_max_bounce_height, 0)
	
	print("Previous: ", previous_velocity)
	# Breaks the soft max bounce height on really high jumps
	if previous_velocity > 1000:
		var bonus_velocity: float = player.velocity.y - (previous_velocity + 1000)
		player.velocity.y = clampf(bonus_velocity, max_bounce_height, 0)
	
	print(player.velocity.y)
	
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
	
	player.velocity.x = move_toward(player.velocity.x, input_axis * player.MAX_MOVE_SPEED, player.ACCELERATION * 2 * delta)

func handle_transitions() -> void:
	if player.is_on_floor():
		if player.get_input_axis():
			state_bot.switch_to_state("Walking")
		else:
			state_bot.switch_to_state("Idle")
		player.play_landing_animation()
