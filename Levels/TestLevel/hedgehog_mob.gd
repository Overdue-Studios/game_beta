extends CharacterBody2D


const SPEED = 30.0
const JUMP_VELOCITY = -400.0

var direction := -1
var turning = false

func _physics_process(delta: float) -> void:
	
	
	#velocity.y +=  200
		
	if is_on_wall():
		print("Wall")
		direction *= -1

	if direction == -1:
		$AnimatedSprite2D.flip_h = true
	else:
		$AnimatedSprite2D.flip_h = false
		
	velocity.x = direction * SPEED
	#else:
	#	velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
	#if $RayCast2D.get_collider() == null and $RayCast2D2.get_collider() == null:
	#	velocity.y +=  200
	#else:
	#	velocity.y = 0
	
	if $RayCast2D.get_collider() != null and $RayCast2D2.get_collider() != null:
		turning = false
	
	if ($RayCast2D.get_collider() == null or $RayCast2D2.get_collider() == null) and not turning:
		print($RayCast2D.get_collider())
		print($RayCast2D2.get_collider())
		turning = true
		direction *= -1
		
	
