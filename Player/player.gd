extends CharacterBody2D

@export var speed = 70
@export var jump_speed = 1800
@export var gravity = 4000
@export var hp : int
@onready var world_clock = get_node("../PhantomCamera2D/UI/Label")
@onready var world_clock_time = 0
@onready var weapon_primary = get_node("Weapon") 
@onready var animationplayer = get_node("Weapon/AnimationPlayer")
signal primary_action
signal secondary_action
signal damage_dealt

var inventory_resource = load("res://Player/inventory.gd")
var inventory = inventory_resource.new()
var weapon_damage = 1

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
	weapon_damage = 15
	weapon_primary.look_at(get_global_mouse_position())
	
	if Input.is_action_pressed("primary_action"):
		animationplayer.play("spear_attack")


func _on_secondary_action():
	weapon_damage = 10


func _on_weapon_hitbox_body_entered(body):
	print("Hit something", body)
	emit_signal("damage_dealt", body, weapon_damage)
