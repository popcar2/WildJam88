extends Control

func _ready() -> void:
	Hud.hide_hud()

func _on_start_game_button_pressed() -> void:
	SceneManager.load_scene("uid://belwxjhsdk1im")


func _on_credits_button_pressed() -> void:
	%CreditsControl.visible = true
	%MainMenuControl.visible = false


func _on_back_button_pressed() -> void:
	%CreditsControl.visible = false
	%MainMenuControl.visible = true
