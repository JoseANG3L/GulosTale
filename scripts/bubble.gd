class_name Bubble
extends RigidBody2D

var picked : bool = false
var freezed : bool = false
var pos : Vector2
var has_die : bool = false

func _ready():
	if freezed:
		freeze = true
		gravity_scale = 0.5
	if picked:
		update_position()
		gravity_scale = 0
	lock_rotation = true

func _process(delta):
	if picked:
		update_position()

func update_position():
	pos = get_node("../Level/Player/PickupPosition").global_position
	$Sprite2D.global_position = pos
	$CollisionShape2D.global_position = pos
	$VisibleOnScreenNotifier2D.global_position = pos

func throw(forward):
	if has_die:
		return
	picked = false
	#set_position(get_node("../PickupPosition").position)
	apply_impulse(Vector2(150 * forward, -160), Vector2(0, 0))
	gravity_scale = 0.5

func _on_visible_on_screen_notifier_2d_screen_exited():
	if has_die:
		return
	destroy()
	print('screen')

func _on_body_entered(body):
	if body is Enemy:
		destroy()
		print('body')
		body.queue_free()
		
func destroy():
	print('diee')
	has_die = true
	get_node("../Level/Player").pickup = false
	queue_free()
