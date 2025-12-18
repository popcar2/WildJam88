extends CharacterBody2D
class_name Player

const MAX_MOVE_SPEED: float = 1000
const ACCELERATION: float = 500
const JUMP_VELOCITY: float = -700

@export var hp: int = 3
@export var knockback_velocity: Vector2 = Vector2(500, -450)

@onready var damagable_reset_timer = $"Damagable Reset Timer"
@onready var animation_player = $SpriteOffset/AnimationPlayer
var is_damagable: bool = true
var tween: Tween

func _physics_process(delta: float) -> void:
	update_tail_animation(delta)
	
	for i in get_slide_collision_count():
		var body = get_slide_collision(i)
		if body.get_collider().is_in_group("hazards"):
			take_damage()

func get_input_axis() -> float:
	return Input.get_axis("move_left", "move_right")

func apply_gravity(delta: float) -> void:
	velocity += get_gravity() * delta

func face_move_direction() -> void:
	if velocity.x > 0:
		$SpriteOffset.scale.x = abs($SpriteOffset.scale.x)
	elif velocity.x < 0:
		$SpriteOffset.scale.x = -abs($SpriteOffset.scale.x)

func jump() -> void:
	InputBuffer.invalidate_buffer_action("jump")
	play_jump_animation()
	velocity.y = JUMP_VELOCITY
	$JumpSFX.play()

func take_damage(source: Node2D = null) -> void:
	if !is_damagable:
		return
	
	hp -= 1
	play_damage_effect()
	is_damagable = false
	animation_player.play("Damage_CoolDown_Animation")
	damagable_reset_timer.start()
	
	if source != null:
		velocity = knockback_velocity
		
		if source.global_position.x > global_position.x:
			velocity.x *= -1

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
	color_tween.tween_property(%AnimatedSprite2D, "modulate", Color(0.8, 0, 0), 0.1)
	color_tween.tween_property(%AnimatedSprite2D, "modulate", Color(1, 1, 1), 0.1)

func update_tail_animation(delta: float):
	%TailSprite.rotation_degrees = move_toward(
		%TailSprite.rotation_degrees, 
		25.0 / (600.0 / velocity.y),
		delta * 300)
	
	%TailSprite.rotation_degrees = clampf(%TailSprite.rotation_degrees, -30, 30)

func reset_tween():
	if tween:
		tween.kill()
	
	tween = create_tween()
	tween.set_parallel()

func _on_damagable_reset_timer_timeout() -> void:
	is_damagable = true
	animation_player.stop()
	damagable_reset_timer.stop()
