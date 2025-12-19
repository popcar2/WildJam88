extends CanvasLayer

var coins := 0
var hearts := 3

@export var full_heart: Texture2D
@export var empty_heart: Texture2D

@onready var heart_nodes := [
	%Heart1,
	%Heart2,
	%Heart3,
]

func add_coin(amount := 1):
	coins += amount
	%CoinLabel.text = str(coins) + "x"

func reset_coins():
	coins = 0
	%CoinLabel.text = str(coins) + "x"

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
