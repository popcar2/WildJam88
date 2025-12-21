extends CanvasLayer

var coins: int = 0
var coins_at_scene_start: int = 0
var hearts: int = 3
var level_time: float = 0.0
var level_running: bool = false

@export var full_heart: Texture2D
@export var empty_heart: Texture2D

@onready var heart_nodes := [
	%Heart1,
	%Heart2,
	%Heart3,
]

@onready var timer_Label = %TimerLabel

func _process(delta: float) -> void:
	if level_running:
		level_time += delta
		_update_timer_label()

func start_level_timer() -> void:
	level_time = 0.0
	level_running = true
	_update_timer_label()

func stop_level_timer() -> void:
	level_running = false

func _update_timer_label() -> void:
	var total_seconds: int = int(level_time)
	@warning_ignore("integer_division")
	var minutes: int = total_seconds / 60
	var seconds: int = total_seconds % 60
	timer_Label.text = "%02d:%02d" % [minutes, seconds]

func add_coin(amount := 1):
	coins += amount
	%CoinLabel.text = str(coins) + "x"

## Resets coins to what it was at the start of the scene
## If full reset, sets it to 0
func reset_coins(full_reset: float = false):
	if full_reset:
		coins = 0
	else:
		coins = coins_at_scene_start
	%CoinLabel.text = str(coins) + "x"

func save_coins():
	coins_at_scene_start = coins

func set_hearts(current_hp: int) -> void:
	hearts = clamp(current_hp, 0, heart_nodes.size())
	_draw_hearts()

func _draw_hearts() -> void:
	for i in range(heart_nodes.size()):
		if i < hearts:
			heart_nodes[i].texture = full_heart
		else:
			heart_nodes[i].texture = empty_heart

func reset_hearts() -> void:
	hearts = heart_nodes.size()   # 3 in your case
	_draw_hearts()

func hide_hud():
	visible = false

func show_hud():
	visible = true
