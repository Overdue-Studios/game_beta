extends CharacterBody2D

@export var speed = 70
@onready var world_clock = get_node("./Label")
@onready var world_clock_time = 0

func _physics_process(delta):
	
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


func _on_world_clock_timeout():
	world_clock_time += 1
	world_clock.text = str(world_clock_time)
