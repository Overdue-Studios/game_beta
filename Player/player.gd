extends CharacterBody2D

@export var speed = 70
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
	
	if Input.is_action_pressed("ui_left") and GameManager.nomove == false:
		velocity.x = -speed
	if Input.is_action_pressed("ui_right") and GameManager.nomove == false:
		velocity.x = speed
	if Input.is_action_pressed("ui_up") and GameManager.nomove == false:
		velocity.y = -speed
	if Input.is_action_pressed("ui_down") and GameManager.nomove == false:
		velocity.y = speed
		
	move_and_slide()
	
	velocity = Vector2.ZERO
	
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
