extends CharacterBody2D

const SPEED = 100.0

var facing_direction = "down"
var is_attacking = false
var damage_dealt = false
var player_health = 100

var is_hurt = false
var is_dead = false
var has_key = false

signal died

func take_damage(amount) -> void:
	if is_dead or is_hurt:
		return
		
	is_hurt = true
	
	if facing_direction == "right":
		$AnimatedSprite2D.play("hurt_right")
	elif facing_direction == "left":
		$AnimatedSprite2D.play("hurt_left")
	elif facing_direction == "up":
		$AnimatedSprite2D.play("hurt_up")
	elif facing_direction == "down":
		$AnimatedSprite2D.play("hurt_down")
	
	player_health = max(player_health - amount, 0)
	
	print("Player Hp: " + str(int(player_health)))
	
	if player_health <= 0:
		is_dead = true

func _physics_process(_delta: float) -> void:
	var direction = Input.get_vector(
		"move_left", 
		"move_right",
		"move_up",
		"move_down"
	)
	
	if is_dead == true:
		velocity = Vector2.ZERO
		
		if facing_direction == "right":
			$AnimatedSprite2D.play("death_right")
		elif facing_direction == "left":
			$AnimatedSprite2D.play("death_left")
		elif facing_direction == "up":
			$AnimatedSprite2D.play("death_up")
		elif facing_direction == "down":
			$AnimatedSprite2D.play("death_down")
	elif is_hurt == true:
		velocity = Vector2.ZERO
	elif is_attacking == true:
		velocity = Vector2.ZERO
	else:
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
	
	
	if Input.is_action_just_pressed("attack") and not is_attacking:
		if facing_direction == "up":
			is_attacking = true
			damage_dealt = false
			$AttackArea.position = Vector2(0, -16)
			$AnimatedSprite2D.play("attack_up")
		elif facing_direction == "down":
			is_attacking = true
			damage_dealt = false
			$AttackArea.position = Vector2(0, 16)
			$AnimatedSprite2D.play("attack_down")
		elif facing_direction == "right":
			is_attacking = true
			damage_dealt = false
			$AttackArea.position = Vector2(16, 0)
			$AnimatedSprite2D.play("attack_right")
		elif facing_direction == "left":
			is_attacking = true
			damage_dealt = false
			$AttackArea.position = Vector2(-16, 0)
			$AnimatedSprite2D.play("attack_left")
			


func _on_attack_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		print("Enemies in area")


func _on_animated_sprite_2d_animation_finished() -> void:
	if str($AnimatedSprite2D.animation).begins_with("attack_"):
		is_attacking = false
	
	if str($AnimatedSprite2D.animation).begins_with("hurt_"):
		is_hurt = false
		
	if str($AnimatedSprite2D.animation).begins_with("death_"):
		print("Player is Dead")
		died.emit()


func _on_animated_sprite_2d_frame_changed() -> void:
	if is_attacking == true and $AnimatedSprite2D.frame == 3 and not damage_dealt:
		var bodies = $AttackArea.get_overlapping_bodies()
		damage_dealt = true
		
		for body in bodies:
			if body.is_in_group("enemies"):
				#print("Attack enemy in area")
				body.take_damage(10)
