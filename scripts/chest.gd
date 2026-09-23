extends StaticBody2D

var is_open = false

@export var open_texture: Texture2D
@export var gives_key = true
@export var gives_potion = true

func _on_interaction_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and not is_open:
		print("Player found the chest!")
		
		is_open = true
		$Sprite2D.texture = open_texture
		print("Chest opened")
		
		if gives_key:	
			body.has_key = true
			print("Got key from chest")
		
		if gives_potion:
			body.heal(20)
			print("Player healed")
