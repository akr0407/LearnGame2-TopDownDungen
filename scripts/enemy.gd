extends CharacterBody2D

const SPEED = 80.0
var facing_direction = "down"
var health = 40

func take_damage(amount) -> void:
	health -= amount
	print("Enemies Hp: " + str(int(health)))
	
	$AnimatedSprite2D.modulate = Color.RED
	
	await get_tree().create_timer(0.1).timeout
	$AnimatedSprite2D.modulate = Color.WHITE
	
	if health <= 0:
		queue_free()
	

func _physics_process(_delta: float) -> void:
	var player = get_tree().get_first_node_in_group("player")
	var distance = position.distance_to(player.position)
	
	if distance > 30:
		var direction = position.direction_to(player.position)
		
		velocity = SPEED * direction
		
		if abs(direction.x) > abs(direction.y):
			if direction.x > 0:
				facing_direction = "right"
				$AnimatedSprite2D.play("walk_right")
			else:
				facing_direction = "left"
				$AnimatedSprite2D.play("walk_left")
		else:
			if direction.y > 0:
				facing_direction = "down"
				$AnimatedSprite2D.play("walk_down")
			else:
				facing_direction = "up"
				$AnimatedSprite2D.play("walk_up")
	else:
		velocity = Vector2.ZERO
		
		if facing_direction == "up":
			$AnimatedSprite2D.play("idle_up")
		elif facing_direction == "down":
			$AnimatedSprite2D.play("idle_down")
		elif facing_direction == "right":
			$AnimatedSprite2D.play("idle_right")
		elif facing_direction == "left":
			$AnimatedSprite2D.play("idle_left")
		else:
			$AnimatedSprite2D.play("idle_down")
		
	move_and_slide()
