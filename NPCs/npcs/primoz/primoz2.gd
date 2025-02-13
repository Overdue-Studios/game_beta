extends StaticBody2D

@onready var player = GameManager.player
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("interact") && $Popup.visible == true:
		get_parent().get_node("ParallaxBackground/DreamState1/DreamState1").visible = true


func _on_body_entered(body: Node2D) -> void:
	if body == player:
		$Popup.visible = true


func _on_body_exited(body: Node2D) -> void:
	if body == player:
		$Popup.visible = false
