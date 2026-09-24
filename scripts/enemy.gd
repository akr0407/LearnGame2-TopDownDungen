extends CharacterBody2D

signal defeated

const SPEED = 80.0

var facing_direction = "down"
var is_attacking = false
var player_in_range = false
var player_in_attack_range = false
var is_dead = false
var knockback_velocity = Vector2.ZERO
#var distance_to_player = 0.0

@export var health = 40
@export var key_scene: PackedScene
@export var drops_key = false

@export var potion_scene: PackedScene
@export var drops_potion = false
#@export var detection_range = 150

func take_damage(amount, knockback_direction = Vector2.ZERO) -> void:
	if health <= 0:
		return

	health -= amount
	print("Enemies Hp: " + str(int(health)))
	
	knockback_velocity = knockback_direction * 150
		
	hit_flash()
	
	if health <= 0:
		if drops_key:
			var key = key_scene.instantiate()
			get_parent().add_child(key)
			key.position = position
		
		if drops_potion:
			var potion = potion_scene.instantiate()
			get_parent().add_child(potion)
			potion.position = position
			
		is_dead = true
		$DamageTimer.stop()
		is_attacking = false
		
		if facing_direction == "up":
			$AnimatedSprite2D.play("death_up")
		elif facing_direction == "down":
			$AnimatedSprite2D.play("death_down")
		elif facing_direction == "right":
			$AnimatedSprite2D.play("death_right")
		elif facing_direction == "left":
			$AnimatedSprite2D.play("death_left")
		
		print("Playing death animation: ", $AnimatedSprite2D.animation)
		
		return
		

func _physics_process(_delta: float) -> void:
	if is_dead:
		velocity = Vector2.ZERO
		return
	
	if knockback_velocity != Vector2.ZERO:
		velocity = knockback_velocity
		knockback_velocity = knockback_velocity.move_toward(Vector2.ZERO, 500 * _delta)
		
		move_and_slide()
		return
		
	var player = get_tree().get_first_node_in_group("player")
	#distance_to_player = position.distance_to(player.position)
	if player.is_dead:
		velocity = Vector2.ZERO
		return
	
	if player_in_range and not player_in_attack_range:
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
		$DamageTimer.stop()
		$DamageTimer.start()
		player_in_attack_range = true


func _on_attack_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		$DamageTimer.stop()
		player_in_attack_range = false


func _on_damage_timer_timeout() -> void:
	if is_dead:
		return
		
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
	print("Animation finished: ", $AnimatedSprite2D.animation)

	if str($AnimatedSprite2D.animation).begins_with("attack_"):
		is_attacking = false

	if str($AnimatedSprite2D.animation).begins_with("death_"):
		print("Death animation finished - removing enemy")
		defeated.emit()
		queue_free()

func _on_animated_sprite_2d_frame_changed() -> void:
	if is_attacking == true and $AnimatedSprite2D.frame == 3 and player_in_attack_range == true:
		var player = get_tree().get_first_node_in_group("player")
		
		player.take_damage(10)
		


func _on_detection_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_range = true
		print("Player detected in orc attack area")


func _on_detection_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_range = false
		print("Player left detection range")
		

func hit_flash() -> void:
	$AnimatedSprite2D.modulate = Color.RED
	await get_tree().create_timer(0.1).timeout
	$AnimatedSprite2D.modulate = Color.WHITE
