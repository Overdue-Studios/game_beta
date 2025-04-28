extends StaticBody2D

@onready var boss = get_node("../Dragon")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimationPlayer.play("up")
	boss.connect("aggro", Callable(self, "door_close"))
	boss.connect("dead", Callable(self, "door_open"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func door_close():
	$AnimationPlayer.play("down")

func door_open():
	$AnimationPlayer.play("up")
