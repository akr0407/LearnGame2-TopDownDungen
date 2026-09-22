extends StaticBody2D

@export var destination: Marker2D

var is_open = false

func _on_interaction_area_body_entered(body: Node2D) -> void:
	print("Player is at the door")

	if body.is_in_group("player") and not is_open:
		print("Player detected!")
		is_open = true
		if body.has_key == true:
			$Sprite2D.visible = false
			$CollisionShape2D.set_deferred("disabled", true)
			body.has_key = false
			if destination:
				body.position = destination.position
		else:
			print("Player dont have key")
