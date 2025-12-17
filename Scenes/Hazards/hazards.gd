extends Area2D

@export var move_speed := 150.0
@export var rotate_speed := 180.0
var start_at_a := true

@onready var sprite: Sprite2D = $Sprite2D
@onready var point_a_node: Node2D = $PointA
@onready var point_b_node: Node2D = $PointB

var point_a_pos: Vector2
var point_b_pos: Vector2
var target_pos: Vector2

func _ready() -> void:
	point_a_pos = point_a_node.global_position
	point_b_pos = point_b_node.global_position
	target_pos = point_b_pos if start_at_a else point_a_pos
	global_position = point_a_pos if start_at_a else point_b_pos
	body_entered.connect(_on_body_entered)

func _physics_process(delta: float) -> void:
	_move_between_points(delta)
	_rotate_sprite(delta)

func _move_between_points(delta: float) -> void:
	global_position = global_position.move_toward(
		target_pos,
		move_speed * delta
	)
	if global_position.distance_to(target_pos) < 2.0:
		_swap_target()

func _swap_target() -> void:
	target_pos = point_a_pos if target_pos == point_b_pos else point_b_pos

func _rotate_sprite(delta: float) -> void:
	sprite.rotation_degrees += rotate_speed * delta

func _on_body_entered(body: Node) -> void:
	if body is Player:
		body.take_damage()
