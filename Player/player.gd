extends CharacterBody2D

@export var speed = 70
@onready var world_clock = get_node("./Label")
@onready var world_clock_time = 0
signal primary_action
signal secondary_action

var inventory_resource = load("res://Player/inventory.gd")
var inventory = inventory_resource.new()

func _physics_process(_delta):
	
	if Input.is_action_pressed("ui_left"):
		velocity.x = -speed
	if Input.is_action_pressed("ui_right"):
		velocity.x = speed
	if Input.is_action_pressed("ui_up"):
		velocity.y = -speed
	if Input.is_action_pressed("ui_down"):
		velocity.y = speed
		
	move_and_slide()
	
	velocity = Vector2.ZERO
	
func _process(_delta):
	if Input.is_action_pressed("primary_action"):
		primary_action.emit()
	if Input.is_action_pressed("secondary_action"):
		secondary_action.emit()

func _on_world_clock_timeout():
	world_clock_time += 1
	world_clock.text = str(world_clock_time)


func _on_primary_action():
	print("left click")


func _on_secondary_action():
	print("right click")
