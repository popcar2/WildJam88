extends CharacterBody2D
class_name Player

const MAX_MOVE_SPEED: float = 1000
const ACCELERATION: float = 500
const JUMP_VELOCITY: float = -700

@export var hp: int = 3

var tween: Tween

func get_input_axis() -> float:
	return Input.get_axis("move_left", "move_right")

func apply_gravity(delta: float) -> void:
	velocity += get_gravity() * delta

func face_move_direction() -> void:
	if velocity.x > 0:
		%AnimatedSprite2D.flip_h = false
	elif velocity.x < 0:
		%AnimatedSprite2D.flip_h = true

func jump() -> void:
	InputBuffer.invalidate_buffer_action("jump")
	play_jump_animation()
	velocity.y = JUMP_VELOCITY

func take_damage() -> void:
	hp -= 1
	play_damage_effect()

# ----- TWEEN ANIMATIONS -----

func play_jump_animation():
	reset_tween()
	tween.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(%AnimatedSprite2D, "scale:y", 1.1, 0.1)
	tween.tween_property(%AnimatedSprite2D, "scale:x", 0.7, 0.1)
	
	tween.chain()
	tween.tween_property(%AnimatedSprite2D, "scale:y", 1, 0.15)
	tween.tween_property(%AnimatedSprite2D, "scale:x", 1, 0.15)

func play_landing_animation():
	reset_tween()
	tween.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(%AnimatedSprite2D, "scale:y", 0.9, 0.1)
	tween.tween_property(%AnimatedSprite2D, "scale:x", 1.2, 0.1)
	
	tween.chain()
	tween.tween_property(%AnimatedSprite2D, "scale:y", 1, 0.15)
	tween.tween_property(%AnimatedSprite2D, "scale:x", 1, 0.15)

func play_damage_effect():
	var color_tween: Tween = create_tween()
	color_tween.tween_property(%AnimatedSprite2D, "self_modulate", Color(0.8, 0, 0), 0.1)
	color_tween.tween_property(%AnimatedSprite2D, "self_modulate", Color(1, 1, 1), 0.1)

func reset_tween():
	if tween:
		tween.kill()
	
	tween = create_tween()
	tween.set_parallel()
