extends Node2D

var player_target : Player
var projectile_scene = preload("uid://1nyvrrqbu24v")

@export var rotation_offset_degrees := 0.0

@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var turret_head: Sprite2D = $"Turret Head"
@onready var projectile_spawn: Node2D = %"Projectile Spawn Location"
@onready var cooldown_timer: Timer = $CooldownTimer

func _ready() -> void:
	anim_player.play("Idle")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if player_target:
		turret_head.look_at(player_target.global_position)
		turret_head.rotation_degrees += rotation_offset_degrees


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		anim_player.stop()
		player_target = body
		$StartTimer.start()


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Player:
		anim_player.play("Idle")
		player_target = null
		_stop_shooting_cooldown_timer()


func _stop_shooting_cooldown_timer() -> void:
	cooldown_timer.stop()
	$StartTimer.stop()


func _shoot() -> void:
	var projectile = projectile_scene.instantiate()
	get_tree().current_scene.add_child(projectile)
	projectile.global_position = projectile_spawn.global_position
	projectile.global_rotation = turret_head.global_rotation



func _on_cooldown_timer_timeout() -> void:
	_shoot()


func _on_start_timer_timeout() -> void:
	_shoot()
	cooldown_timer.start()
