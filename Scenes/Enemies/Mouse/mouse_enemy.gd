extends Area2D

@export var speed: float = 400
var tween: Tween
var death_particles_scn: PackedScene = preload("uid://drdgw0dqkgy61")

func _ready() -> void:
	play_walk_animation()

func _physics_process(delta: float) -> void:
	position.x += speed * delta

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.take_damage(self)

func play_walk_animation():
	reset_tween()
	tween.set_loops()
	tween.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property($Sprite2D, "scale:y", 0.72, 0.2)
	tween.tween_property($Sprite2D, "scale:x", 0.8, 0.2)
	
	tween.chain()
	tween.tween_property($Sprite2D, "scale:y", 0.75, 0.15)
	tween.tween_property($Sprite2D, "scale:x", 0.75, 0.15)

func reset_tween():
	if tween:
		tween.kill()
	
	tween = create_tween()
	tween.set_parallel()


func _on_floor_check_area_body_exited(body: Node2D) -> void:
	if body is TileMapLayer:
		scale.x *= -1
		speed *= -1


func _on_bounce_area_body_entered(body: Node2D) -> void:
	if body is Player:
		if body.get_state() == "Dash":
			body.set_state("Bounce")
			var death_particles: GPUParticles2D = death_particles_scn.instantiate()
			death_particles.global_position = global_position
			add_sibling(death_particles)
			queue_free()
