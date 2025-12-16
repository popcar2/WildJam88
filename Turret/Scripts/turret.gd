extends Node2D

var player_target : Player
var projectile_scene = preload("res://Projectile/Scenes/projectile.tscn")
@export var cooldown : float
@onready var anim_player = $AnimationPlayer
@onready var turret_head = $"Turret Head"
@onready var projectile_spawn = $"Turret Head/Turret Muzzle 1/Projectile Spawn Location"
@onready var timer = $Timer

func _ready() -> void:
	timer.wait_time = cooldown
	anim_player.play("Idle")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player_target:
		turret_head.look_at(player_target.position)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		anim_player.stop()
		player_target = body
		_start_shooting_timer()


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Player:
		anim_player.play("Idle")
		player_target = null
		_stop_shooting_timer()


func _start_shooting_timer() -> void:
	timer.start()
	pass


func _stop_shooting_timer() -> void:
	timer.stop()
	timer.wait_time = cooldown;
	pass


func _shoot() -> void:
	print("Shoot")
	var projectile = projectile_scene.instantiate()
	get_tree().current_scene.add_child(projectile)
	projectile.global_position = projectile_spawn.global_position
	projectile.rotation_degrees = turret_head.rotation_degrees
	pass


func _on_timer_timeout() -> void:
	_shoot()
