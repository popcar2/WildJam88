extends Node2D
var player_target : Node2D
var is_target_in_range : bool
@onready var anim_player = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_target_in_range:
		pass
		# TODO: Lock onto target and start shooting
	else:
		anim_player.play("Idle")


func _on_area_2d_body_entered(body: Node2D) -> void:
	is_target_in_range = true;


func _on_area_2d_body_exited(body: Node2D) -> void:
	is_target_in_range = false;
