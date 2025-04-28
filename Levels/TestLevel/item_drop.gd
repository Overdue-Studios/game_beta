extends Node2D

@onready var player = get_tree().get_root().get_node("/root/map_root/Player")
@export var item_name : String
@export var quantity : int

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_2d_body_entered(body):
	if body == player:
		player.inventory.add_item("Sheckel", 5)
		$AnimationPlayer.play("item_pickup_animation")
		

func pickup_animation():
	while rotation != 360:
		rotation += 1


func _on_animation_player_animation_finished(anim_name):
	self.queue_free()
