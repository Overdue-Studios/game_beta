extends Sprite2D
@onready var animationplayer = get_node("./AnimationPlayer")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	look_at(get_global_mouse_position())
	
	if Input.is_action_pressed("primary_action"):
		$AnimationPlayer.play("spear_attack")

