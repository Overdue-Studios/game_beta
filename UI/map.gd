extends Node2D

@onready var player = GameManager.player
@onready var payer_position = $PlayerPosition

func _process(delta):
	# Convert player's global position to map coordinates
	# Adjust scaling_factor based on your map's size and world scale
	var scaling_factor = Vector2(0.1, 0.1) # Example: scale down by 10%
	payer_position.position = player.global_position * scaling_factor
