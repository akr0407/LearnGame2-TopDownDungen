extends CharacterBody2D

const SPEED = 80.0
var facing_direction = "down"
var health = 40
var is_attacking = false
var player_in_range = false

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
	#var distance = position.distance_to(player.position)
	if player.is_dead:
		velocity = Vector2.ZERO
		return
	
	if not player_in_range:
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
		
		if not is_attacking:
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


func _on_attack_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		$DamageTimer.start()
		player_in_range = true
		print("Player in orc area")


func _on_attack_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		$DamageTimer.stop()
		player_in_range = false


func _on_damage_timer_timeout() -> void:
	var player = get_tree().get_first_node_in_group("player")
	
	if player.is_dead:
		return
	
	is_attacking = true
	
	var direction = position.direction_to(player.position)
	
	if abs(direction.x) > abs(direction.y):
		if direction.x > 0:
			facing_direction = "right"
			$AnimatedSprite2D.play("attack_right")
		else:
			facing_direction = "left"
			$AnimatedSprite2D.play("attack_left")
	else:
		if direction.y > 0:
			facing_direction = "down"
			$AnimatedSprite2D.play("attack_down")
		else:
			facing_direction = "up"
			$AnimatedSprite2D.play("attack_up")


func _on_animated_sprite_2d_animation_finished() -> void:
	if str($AnimatedSprite2D.animation).begins_with("attack_"):
		is_attacking = false


func _on_animated_sprite_2d_frame_changed() -> void:
	if is_attacking == true and $AnimatedSprite2D.frame == 3 and player_in_range == true:
		var player = get_tree().get_first_node_in_group("player")
		
		player.take_damage(10)
		
