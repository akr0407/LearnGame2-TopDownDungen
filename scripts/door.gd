extends StaticBody2D


func _on_interaction_area_body_entered(body: Node2D) -> void:
	print("Player is at the door")

	if body.is_in_group("player"):
		print("Player detected!")
		if body.has_key == true:
			$Sprite2D.visible = false
			$CollisionShape2D.set_deferred("disabled", true)
			body.has_key = false
		else:
			print("Player dont have key")
