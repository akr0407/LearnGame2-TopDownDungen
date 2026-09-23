extends Area2D

@export var heal_amount = 20

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.heal(heal_amount)
		print("Picked Up potion")
		queue_free()
