extends StaticBody2D

@onready var player
@onready var player_direction

var horizontal_speed = 1
var vertical_speed = 1

func _init_node(pl):
	player = pl
	player_direction = self.global_position.direction_to(player.global_position)
	

func _ready() -> void:
	$AnimatedSprite2D.play("default")
	print("Fireball player: ", player)
	print("Horizontal speed :", horizontal_speed)
	print("Vertical speed :", vertical_speed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	self.position.x += horizontal_speed * player_direction.x
	self.position.y += vertical_speed * player_direction.y


func _on_area_2d_body_entered(body: Node2D) -> void:
	print(body)
	queue_free()
