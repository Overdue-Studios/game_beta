extends Node2D

const SCALING_FACTOR = Vector2(0.207, 0.207)
const OFFSETS = Vector2(220, 350.6102)
const PLAYER_HEIGHT = Vector2(0, 35.0)

const MAP_SCALE = Vector2(0.2, 0.2)
const MAP_OFFSET = Vector2(0, 10.0)
const PLAYER_POSITION_SCALE = Vector2(0.2, 0.5)

@onready var player = GameManager.player
@onready var player_position = $PlayerPosition
@onready var minimap = $Map

func _ready():
	minimap.visible = false  # Hide map on startup
	player_position.visible = false  # Hide player position marker too
	
	# Scale the sprites
	minimap.scale = MAP_SCALE
	player_position.scale = PLAYER_POSITION_SCALE

func _process(delta):
	if minimap.visible:		
		# Update player position marker
		minimap.global_position = player.global_position - MAP_OFFSET
		player_position.global_position = (player.global_position - OFFSETS + PLAYER_HEIGHT) * SCALING_FACTOR + minimap.global_position
	
	if Input.is_action_just_pressed("OpenMap"):
		# Toggle map visibility
		minimap.visible = !minimap.visible
		player_position.visible = !player_position.visible
