extends Control

@export var level: PackedScene = preload("res://Levels/TestLevel/map_root.tscn")
var level_instance

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("LoadLevel"):
		GameManager.player.damage(20)

func load_level() -> void:
	# Remove all children
	if level_instance:
		level_instance.queue_free()
	
	level_instance = level.instantiate()
	add_child(level_instance)
