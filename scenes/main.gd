extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$UI/HUD/HealthBar.value = $Player.player_health
	$UI/HUD/HealthBar/HealthLabel.text = str($Player.player_health) + " / 100 HP"


func _on_player_died() -> void:
	$UI/HUD/GameOverPanel.visible = true


func _on_restart_button_pressed() -> void:
	get_tree().reload_current_scene()


func _on_exit_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		print("Player reached exit")
		$UI/HUD/EscapePanel.visible = true


func _on_play_again_button_pressed() -> void:
	get_tree().reload_current_scene()


func _on_exit_button_pressed() -> void:
	get_tree().quit()
