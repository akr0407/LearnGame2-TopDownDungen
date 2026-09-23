extends StaticBody2D

@export var destination: Marker2D

var is_open = false

func _on_interaction_area_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return

	print("Player is at the door")

	if is_open:
		if destination:
			body.position = destination.position
		return

	if body.has_key:
		is_open = true
		$Sprite2D.visible = false
		$CollisionShape2D.set_deferred("disabled", true)

		body.has_key = false

		if destination:
			body.position = destination.position
	else:
		print("Player doesn't have key")
		
func open_door(body: Node2D = null) -> void:
	if is_open:
		return

	is_open = true
	$Sprite2D.visible = false
	$CollisionShape2D.set_deferred("disabled", true)

	print("Door opened!")

	if body and destination:
		body.position = destination.position
