extends Area2D

@export var speed: float = 400
var tween: Tween

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
