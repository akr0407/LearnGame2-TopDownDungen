extends CharacterBody2D

const SPEED = 100.0
var facing_direction =  "down"

func _physics_process(delta: float) -> void:
	var direction = Input.get_vector(
		"move_left", 
		"move_right",
		"move_up",
		"move_down"
	)
	
	if direction != Vector2.ZERO:
		if direction.x > 0:
			facing_direction = "right"
			$AnimatedSprite2D.play("walk_right")
		elif direction.x < 0: 
			facing_direction = "left"
			$AnimatedSprite2D.play("walk_left")
		elif direction.y > 0:
			facing_direction = "down"
			$AnimatedSprite2D.play("walk_down")
		elif  direction.y < 0:
			facing_direction = "up"
			$AnimatedSprite2D.play("walk_up")
	else:
		if facing_direction == "right":
			$AnimatedSprite2D.play("idle_right")
		elif facing_direction == "left": 
			$AnimatedSprite2D.play("idle_left")
		elif facing_direction == "down":
			$AnimatedSprite2D.play("idle_down")
		elif facing_direction == "up":
			$AnimatedSprite2D.play("idle_up")
	
	velocity = SPEED * direction
	
	move_and_slide()
