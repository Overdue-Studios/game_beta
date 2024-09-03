extends StaticBody2D

var horizontal_speed = 5
var vertical_speed = 5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	horizontal_speed = 1
	vertical_speed = 1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	self.position.x += horizontal_speed 
	self.position.y += vertical_speed 
