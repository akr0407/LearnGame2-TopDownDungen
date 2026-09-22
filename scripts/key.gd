extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		print("Player at key")
		body.has_key = true
		print("Player picked up the key")
		print("Has key: ", body.has_key)
		queue_free()
