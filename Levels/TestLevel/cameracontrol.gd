extends Area2D

@onready var camera_control = get_tree().get_root().get_node("/root/map_root/BossCam")
@onready var player = get_tree().get_root().get_node("/root/map_root/Player")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#desna vrata
func _on_body_entered(body: Node2D) -> void:
	print(body)
	if body == player:
		camera_control.priority = 3

#leva vrata
func _on_area_2d_2_body_entered(body: Node2D) -> void:
	print("door entered")
	if body == player:
		camera_control.priority = 1
