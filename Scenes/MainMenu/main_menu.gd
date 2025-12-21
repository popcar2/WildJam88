extends Control

func _ready() -> void:
	Hud.hide_hud()
	%StartGameButton.grab_focus()

func _on_start_game_button_pressed() -> void:
	SceneManager.load_scene("uid://belwxjhsdk1im")


func _on_credits_button_pressed() -> void:
	%CreditsControl.visible = true
	%MainMenuControl.visible = false
	%BackButton.grab_focus()


func _on_back_button_pressed() -> void:
	%CreditsControl.visible = false
	%MainMenuControl.visible = true
	%StartGameButton.grab_focus()
