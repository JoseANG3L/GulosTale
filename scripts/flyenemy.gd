extends Enemy


func move_enemy(delta):
	velocity.x = direction * speed
	move_and_slide()

func get_direction():
	sprite.scale.x = direction
	if raycast_platform.is_colliding():
		direction *= -1

func get_raycast_platform():
	if raycast_platform.is_colliding():
		var collision = raycast_platform.get_collider()
		if collision is Platform:
			if collision.death_collision:
				destroy()
