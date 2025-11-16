extends StaticBody2D

var has_die : bool = false

func _ready():
	await get_tree().create_timer(2.0).timeout
	queue_free()
	
func destroy():
	print('die static bubble')
	has_die = true
	queue_free()
