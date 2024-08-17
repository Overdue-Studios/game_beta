extends CharacterBody2D

@onready var player = get_node("/root/map_root/Player")
@onready var dialogue = preload("res://NPCs/dialogue.tscn")
@onready var interact_popup = preload("res://NPCs/interact_popup.tscn")
@onready var instance
@onready var interactable = false
@onready var dialogue_window
@onready var dialogue_text
func _ready():
	pass
	
func _process(_delta):
	if Input.is_action_just_pressed("interact") and interactable:
		get_tree().paused = true
		interactable = false
		dialogue_window = dialogue.instantiate()
		add_child(dialogue_window)
		dialogue_text = get_node("Dialogue/NinePatchRect/Text")
		dialogue_text.text = "jou"
		GameManager.nomove = true
	
	

func _on_area_2d_body_entered(body):
	if body == player:
		instance = interact_popup.instantiate()
		add_child(instance)
		interactable = true

func _on_area_2d_body_exited(body):
	if body == player:
		instance.free()
		interactable = false
