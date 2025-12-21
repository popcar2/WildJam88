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
var is_dead: bool = false
var finished_initial_bounce: bool = false
var tween: Tween

func _ready() -> void:
	Hud.reset_hearts()
	Hud.reset_coins()
	Hud.show_hud()

func _physics_process(delta: float) -> void:
	update_tail_animation(delta)
	
	if velocity.y >= 3000:
		die()
	
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
	
	Hud.set_hearts(hp)
	
	play_damage_effect()
	is_damagable = false
	animation_player.play("Damage_CoolDown_Animation")
	damagable_reset_timer.start()
	
	# Add knockback
	if source != null:
		velocity = knockback_velocity
		
		if source.global_position.x > global_position.x:
			velocity.x *= -1
	
	if hp <= 0:
		die()
	else:
		if randi_range(0, 1) == 0:
			$DmgSFX1.play()
		else:
			$DmgSFX2.play()

func die():
	if is_dead:
		return
	
	is_dead = true
	$DeathSFX.play()
	
	var death_tween: Tween = create_tween()
	death_tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC).set_parallel()
	death_tween.set_ignore_time_scale()
	death_tween.tween_property(get_tree().current_scene, "modulate", Color(0.6, 0.6, 0.6), 1)
	death_tween.tween_property(Engine, "time_scale", 0.1, 1)
	await death_tween.tween_property($Camera2D, "zoom", Vector2(1, 1), 1).finished
	
	SceneManager.load_scene()

## Used when checking state from other entities
func get_state() -> String:
	return $StateBot.current_state.name

## Used to force player to bounce
func set_state(state: String) -> void:
	$StateBot.switch_to_state(state)

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
