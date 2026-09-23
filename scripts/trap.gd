extends Area2D

@export var damage = 10
@export var cooldown = 1.0

var can_damage = true

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and can_damage:
		print("Player stepped on trap")
		
		can_damage = false
		
		$AnimatedSprite2D.play("activated")
		body.take_damage(damage)
		
		await get_tree().create_timer(cooldown).timeout
		can_damage = true


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		$AnimatedSprite2D.stop()
		$AnimatedSprite2D.frame = 0
