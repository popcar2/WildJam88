@warning_ignore("missing_tool")
extends SimpleState

@onready var player: Player = state_bot.puppet
@onready var animated_sprite: AnimatedSprite2D = %AnimatedSprite2D

@export var dash_speed: float = 500

var biggest_velocity: float

func _enter_state(_last_state: SimpleState) -> void:
	biggest_velocity = 0
	if player.velocity.y < dash_speed:
		player.velocity.y = dash_speed
	
	var tween: Tween = create_tween()
	tween.set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.tween_property(%AnimatedSprite2D, "rotation_degrees", 95, 0.5)


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
	
	if player.velocity.y > biggest_velocity:
		biggest_velocity = player.velocity.y


func handle_movement(delta: float):
	var input_axis: float = player.get_input_axis()
	
	player.velocity.x = move_toward(player.velocity.x, input_axis * player.MAX_MOVE_SPEED, player.ACCELERATION * delta)
	


func handle_transitions():
	if player.is_on_floor():
		state_bot.switch_to_state("Bounce")
