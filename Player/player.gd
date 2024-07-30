extends CharacterBody2D

@export var speed = 70
@export var jump_speed = 1800
@export var gravity = 4000
@export var hp : int
@onready var world_clock = get_node("../PhantomCamera2D/UI/Label")
@onready var world_clock_time = 0
signal primary_action
signal secondary_action

var inventory_resource = load("res://Player/inventory.gd")
var inventory = inventory_resource.new()

var tab_inventory = load("res://Player/TabInventory.tscn")
var inventory_open = false
func _ready():
	pass




func _physics_process(_delta):
	velocity.y += gravity * _delta
	
	if GameManager.nomove == false:
		velocity.x = Input.get_axis("ui_left", "ui_right") * speed
	else:
		velocity.x = 0
		
	move_and_slide()
	
	if Input.is_action_just_pressed("ui_up") and GameManager.nomove == false and is_on_floor() == true:
		velocity.y = -jump_speed
	
func _process(_delta):
	if Input.is_action_pressed("primary_action"):
		primary_action.emit()
	if Input.is_action_pressed("secondary_action"):
		secondary_action.emit()
	if Input.is_action_just_pressed("inventory"):
		get_tree().paused = true
		inventory_open = true
		var tab_inventory_ui = tab_inventory.instantiate()
		add_child(tab_inventory_ui)
		GameManager.nomove = true
		
	if Input.is_action_just_pressed("interact2"):
		inventory.add_item("Sheckel", 2)
		
		

func _on_world_clock_timeout():
	world_clock_time += 1
	world_clock.text = str(world_clock_time)


func _on_primary_action():
	pass


func _on_secondary_action():
	pass
