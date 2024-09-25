extends Area2D

var active = false
# Called when the node enters the scene tree for the first time.
func _ready():
	connect("body_entered", self._on_npc_body_entered)
	connect("body_exited", self._on_npc_body_exited)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Popup.visible = active
	
func _on_npc_body_entered(body: CharacterBody2D):
	print("hi")
	active = true
			
func _on_npc_body_exited(body: CharacterBody2D):
	print("bye")
	active = false
