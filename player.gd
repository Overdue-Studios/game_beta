extends CharacterBody2D

@export var speed = 70

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
