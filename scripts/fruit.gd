class_name Fruit
extends Area2D

var has_die : bool = false
@onready var animation_player = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	animation_player.speed_scale = 0.8
	animation_player.play("idle")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func destroy():
	has_die = true
	queue_free()

func _on_body_entered(body):
	if body is Player:
		destroy()
