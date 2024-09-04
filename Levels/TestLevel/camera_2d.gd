extends Camera2D

@onready var bosscam = %BossCam
@export var magnitude = 0
@onready var shaking = false
@onready var start_frame = 0
@onready var time = 0
var is_shaking : bool = false
var shake_amt : Vector2 = Vector2.ZERO

func _process(delta: float) -> void:
	if shaking and Engine.get_frames_drawn() < (start_frame + time*60):
		print("shaking")
		shake_amt = Vector2(randf_range(-1, 1), randf_range(-1,1)) * magnitude
		bosscam.global_position += shake_amt
	else:
		shaking = false
		bosscam.global_position = Vector2(624, 284)

func shake(shake_magnitude : float, shake_time : float):
	shaking = true
	start_frame = Engine.get_frames_drawn()
	magnitude = shake_magnitude
	time = shake_time
	print(start_frame)
	
