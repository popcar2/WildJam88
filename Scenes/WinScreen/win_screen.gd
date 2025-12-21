extends Control

func _ready() -> void:
	Hud.hide_hud()
	%CoinCountLabel.text = "You've collected %d/276 coins!" % Hud.coins
	%TimeLabel.text = "You won in only %02d:%02d" % [Hud.level_time / 60, int(Hud.level_time) % 60]
	
	if Hud.level_time < 90 or Hud.coins == 276:
		%GrassTexture.visible = true


func _on_back_to_menu_button_pressed() -> void:
	SceneManager.load_scene("res://Scenes/MainMenu/main_menu.tscn")
