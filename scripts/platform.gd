class_name Platform
extends CharacterBody2D

@export var speed_scale = 2

@onready var animation = $AnimationPlayer
@onready var left_platform = $LeftPlatform
@onready var right_platform = $RightPlatform

var can_hit : bool = true
var death_collision : bool = false


func jump():
	animation.speed_scale = 4.0
	animation.play("jump")
	if left_platform.is_colliding():
		var collision = left_platform.get_collider()
		if collision is Platform:
			collision.jump_low()
	if right_platform.is_colliding():
		var collision = right_platform.get_collider()
		if collision is Platform:
			collision.jump_low()
	
func jump_low():
	animation.speed_scale = 4.0
	animation.play("jump_low")
	#set_process(false)

func _on_animation_player_animation_started(anim_name):
	can_hit = false
	death_collision = true
	
func _on_animation_player_animation_finished(anim_name):
	can_hit = true
	death_collision = false
