extends Node2D

@onready var player = GameManager.player
@onready var player_position = $PlayerPosition
@onready var minimap = $Map

func _ready():
	minimap.visible = false  # Hide map on startup
	player_position.visible = false  # Hide player position marker too
	
	minimap.scale = Vector2(0.18, 0.18)

func _process(delta):
	# Convert player's global position to map coordinates
	# Adjust scaling_factor based on your map's size and world scale
	var scaling_factor = Vector2(0.1, 0.1) # Example: scale down by 10%
	player_position.position = player.global_position * scaling_factor
	
	#print(player.global_position)
	
	if minimap.visible:		
		# Update player position marker
		minimap.global_position = Vector2(player.global_position.x, player.global_position.y - 10)
	
	if Input.is_action_just_pressed("OpenMap"):
		print(minimap.position)
		minimap.visible = !minimap.visible
