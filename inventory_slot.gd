extends TextureRect

signal start_hover
signal stop_hover

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("InvSlots")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_mouse_entered():
	emit_signal("start_hover", extract_number_from_node_name(str(self)))
	#print(extract_number_from_node_name(str(self)))


func _on_mouse_exited():
	emit_signal("stop_hover", extract_number_from_node_name(str(self)))


func _on_pressed():
	pass # Replace with function body.

func extract_number_from_node_name(node_name: String) -> int:
	var regex = RegEx.new()
	# Pattern explanation:
	# - `InventorySlot` matches the literal text.
	# - `(\d+)` captures one or more digits and stores them in a capture group.
	regex.compile("InventorySlot(\\d+)")
	
	var match = regex.search(node_name)
	if match:
		# The captured number is the first capture group (index 1)
		return match.get_string(1).to_int()
	
	return -1 # Return a default value if no match is found
