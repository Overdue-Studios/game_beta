extends Area2D

@onready var player = GameManager.player

func _on_body_entered(body: Node2D) -> void:
	if body == player:
		SceneSwap.change_scene("res://Levels/Gmayna/gmayna.tscn")
