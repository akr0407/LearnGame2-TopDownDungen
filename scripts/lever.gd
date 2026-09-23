extends StaticBody2D


var is_activated = false

@export var activated_texture: Texture2D
@export var target_door: StaticBody2D

func _on_interaction_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and not is_activated:
		print("Player reached the lever")
		is_activated = true
		
		$Sprite2D.texture = activated_texture
		
		if target_door:
			target_door.open_door()
