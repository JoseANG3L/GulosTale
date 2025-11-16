class_name Player
extends CharacterBody2D

@export var speed : int = 150
@export var gravity : float = 600
@export var jump_force : int = 200
@export var jump_buffer_time : int  = 10
@export var cayote_time : int = 10
@export var object_offset : float = 35

@onready var tilemap = $"../TileMapLayer"
@onready var object_raycast = $ObjectDetector
@onready var camera = $Camera2D
@onready var sprite = $Sprite2D
@onready var animation = $AnimationPlayer
@onready var bubble_position = $BubblePosition

const bubble = preload("res://objects/bubble.tscn")
const static_bubble = preload("res://objects/bubbleStatic.tscn")

var jump_buffer_counter : int = 0
var cayote_counter : int = 0
var direction : float = 1
var input : float = 0
var drop_bubble : bool = true
var pickup : bool = false
var has_die : bool = false
var last_bubble : RigidBody2D

var state : String = "idle"
var current_state : String = ""


func _ready():
	camera.position_smoothing_enabled = true
	camera.position_smoothing_speed = 5

func _process(delta):
	#print(state)
	get_input()
	fix_camera()
	do_gravity(delta)
	coyote_jump()
	player_movement()
	update_animation()
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		print("I collided with ", collision.get_collider().name)
		if (collider.name == 'BubbleStatic'):
			if collider.has_node(".."):
				#collider.get_parent().update_position()
				print(collider.name)
				collider.destroy()

func fix_camera():
	camera.drag_horizontal_offset = 0.2 * input

func get_input():
	input = Input.get_axis("ui_left", "ui_right")
	if input != 0:
		direction = input
	var char_pos = tilemap.local_to_map(global_position)
	var pos = tilemap.map_to_local(Vector2i(char_pos.x + direction, char_pos.y))
	object_raycast.target_position = Vector2(object_offset * direction, 0)
	
	if Input.is_action_just_pressed("bubble") and current_state != "bubble_jump":
		if not object_raycast.is_colliding():
			spawn_bubble_static(pos)
	if Input.is_action_just_pressed("bubble_hit") and current_state != "bubble_jump":
		spawn_bubble()
		
	if Input.is_action_just_pressed("bubble_left") and current_state != "bubble_jump":
		bubble_jump()

func bubble_jump():
	print("bubble jump")
	state = "bubble_jump"
	
	var char_pos = tilemap.local_to_map(global_position)
	var pos = tilemap.map_to_local(Vector2i(char_pos.x + direction, char_pos.y))
	object_raycast.target_position = Vector2(object_offset * direction, 0)
	var b = static_bubble.instantiate()
	b.position = pos
	owner.add_child(b)
	bubble_position = b.position + Vector2(0,-40)
	animation.play("bubble_jump")

func spawn_bubble_static(pos):
	var b = static_bubble.instantiate()
	b.position = pos
	owner.add_child(b)

func spawn_bubble():
	var collide_player
	if is_instance_valid(last_bubble):
		#var b = get_node("Bubble")
		last_bubble.throw(direction)
		last_bubble = null
	else:
		var b = bubble.instantiate()
		b.picked = true
		owner.add_child(b)
		last_bubble = b

func player_movement():
	velocity.x = speed * input
	if velocity.x != 0 and state not in ["jump","fall"] and current_state != "bubble_jump":
		state = "walk"
	if direction > 0:
		sprite.flip_h = false
	elif direction < 0:
		sprite.flip_h = true
	move_and_slide()

func do_gravity(delta):
	if not is_on_floor():
		if velocity.y > 0 and current_state != "bubble_jump":
			state = "fall"
		velocity.y += gravity * delta

func coyote_jump():
	if is_on_floor():
		if current_state != "bubble_jump":
			state = "idle"
			cayote_counter = cayote_time
	else:
		if cayote_counter > 0:
			cayote_counter -= 1
	
	if Input.is_action_just_pressed("ui_up") and current_state != "bubble_jump":
		jump_buffer_counter = jump_buffer_time
		#print(velocity.y)
	
	if jump_buffer_counter > 0:
		jump_buffer_counter -= 1
	
	if jump_buffer_counter > 0 and cayote_counter > 0 and current_state != "bubble_jump":
		do_jump()
		jump_buffer_counter = 0
		cayote_counter = 0
	#
	if Input.is_action_just_released("ui_up") and current_state != "bubble_jump":
		state = "fall"
		if velocity.y < 0:
			velocity.y = -60

func do_jump():
	if current_state != "bubble_jump":
		state = "jump"
		velocity.y = -jump_force

func update_animation():
	if current_state != state:
		current_state = state
		print('current_state', current_state)
		animation.speed_scale = 1.8
		if current_state == "bubble_jump":
			animation.speed_scale = 1.4
			animation.play("bubble_jump")
		else:
			if current_state == "walk":
				animation.play("walk")
			elif current_state == "idle":
				animation.play("idle")
			elif current_state in ["jump","fall"]:
				animation.play("jump")

func destroy():
	global_position = $"../StartPosition".global_position
	return
	has_die = true
	queue_free()


func _on_area_hit_body_entered(body):
	print('body > ', body)
	if body is Enemy:
		body.destroy()
		do_jump()


func _on_area_platform_body_entered(body):
	if body is Platform and state == "jump":
		body.jump()
