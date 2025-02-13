extends Area2D
@onready var player = GameManager.player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if body == player:
		player.climbing = true


func _on_body_exited(body: Node2D) -> void:
	if body == player:
		player.climbing = false
