extends Node2D

@onready var player = $Player
@onready var start_position = $StartPosition

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.global_position = start_position.global_position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
