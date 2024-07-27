extends Node2D

# Common properties
@export var health: int = 100
@export var speed: int = 200

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Common movement logic
	pass

# Common attack logic
func attack():
	print("Enemy attacks!")

# Function to take damage
func take_damage(damage: int):
	health -= damage
	if health <= 0:
		die()

# Function to handle enemy death
func die():
	print("Enemy dies")
	queue_free()
