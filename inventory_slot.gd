extends Button


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_mouse_entered():
	if get_node("Quantity").text != "":
		get_node("Background").visible = true
		#get_node("Background/Name").text = "asdfads"


func _on_mouse_exited():
	get_node("Background").visible = false


func _on_pressed():
	pass # Replace with function body.
