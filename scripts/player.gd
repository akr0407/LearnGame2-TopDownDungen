extends CharacterBody2D

const SPEED = 100.0

func _physics_process(delta: float) -> void:
	var direction = Input.get_vector(
		"move_left", 
		"move_right",
		"move_up",
		"move_down"
	)
	
	if direction != Vector2.ZERO:
		if direction.x > 0:
			$AnimatedSprite2D.play("idle_right")
		elif direction.x < 0: 
			$AnimatedSprite2D.play("idle_left")
		elif direction.y > 0:
			$AnimatedSprite2D.play("idle_down")
		elif  direction.y < 0:
			$AnimatedSprite2D.play("idle_up")
	
	velocity = SPEED * direction
	
	move_and_slide()
