class_name Enemy
extends CharacterBody2D

@export var speed : int = 17
@onready var raycast_platform = $"Sprite2D/RayCastPlatform"
@onready var sprite = $Sprite2D

var direction : int = 1
var has_die : bool = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	get_direction()
	get_raycast_platform()
	move_enemy(delta)

func move_enemy(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	velocity.x = direction * speed
	move_and_slide()

func get_direction():
	sprite.scale.x = direction
	if not raycast_platform.is_colliding() or is_on_wall():
		direction *= -1

func get_raycast_platform():
	if raycast_platform.is_colliding():
		var collision = raycast_platform.get_collider()
		if collision is Platform:
			if collision.death_collision:
				destroy()

func destroy():
	print('diee')
	has_die = true
	queue_free()

func _on_area_2d_body_entered(body):
	if body is Player:
		body.destroy()
