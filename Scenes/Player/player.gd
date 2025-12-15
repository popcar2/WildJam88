extends CharacterBody2D
class_name Player

const MAX_MOVE_SPEED: float = 1000
const ACCELERATION: float = 500
const JUMP_VELOCITY: float = -700

func get_input_axis() -> float:
	return Input.get_axis("move_left", "move_right")

func apply_gravity(delta: float) -> void:
	velocity += get_gravity() * delta

func face_move_direction() -> void:
	if velocity.x > 0:
		%AnimatedSprite2D.flip_h = false
	elif velocity.x < 0:
		%AnimatedSprite2D.flip_h = true
