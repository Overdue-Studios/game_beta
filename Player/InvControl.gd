extends Control

@onready var InvSlots = get_children()
@onready var ItemSlot = load("res://item.tscn")
# Called when the node enters the scene tree for the first time.
@onready var hovered_slot
@onready var hovered_slot_index
@onready var dragged_item
@onready var dragged_item_index
@onready var Inv
@onready var item_storage
@onready var drag_start_slot
func _ready():
	var player = get_tree().get_root().get_node("/root/map_root/Player")
	GameManager.connect("player_initialised", Callable(self,"_on_player_initialised"))
	
	Inv = player.inventory.get_items()
	print(InvSlots)
	player.inventory.connect("inventory_changed", Callable(self, "_on_player_inventory_changed"))
	for i in range(Inv.size()-1):
		if Inv[i] != null:
			var item = ItemSlot.instantiate()
			item.texture = Inv[i].item_reference.texture
			item.get_children()[0].text = str(Inv[i].quantity)
			InvSlots[i].z_index = 0  # Ensure slots are below items
			InvSlots[i].add_child(item)
	
	connect_to_signal_in_tree("InvSlots" ,"start_hover", "_hover_start")
	connect_to_signal_in_tree("InvSlots" ,"stop_hover", "_hover_stop")
	connect_to_signal_in_tree("InvItems" ,"drag_start", "_drag_start")
	connect_to_signal_in_tree("InvItems", "drag_stop", "_drag_stop")
		
func _process(_delta):
	if Input.is_action_just_pressed("inventory"):
		GameManager.nomove = false

func _on_player_inventory_changed(inventory):
	for n in get_children():
		n.queue_free()
		
	for item in inventory.get_items():
		var item_label = Label.new()
		item_label.text = "%s x%d" % [item.item_reference.name, item.quantity]
		add_child(item_label)

func connect_to_signal_in_tree(tree: String, signal_name: String, method_name: String):
	var nodes = get_tree().get_nodes_in_group(tree)
	for node in nodes:
		if node.has_signal(signal_name):
			node.connect(signal_name, Callable(self, method_name))


func _hover_start(arg1):
	hovered_slot = arg1
	hovered_slot_index = extract_number_from_node_name(str(arg1))-1
	print("hovered slot = ",hovered_slot, " ", hovered_slot_index)
	#print(get_children()[0].get_children())
	
func _hover_stop(arg1):
	hovered_slot = null
	print("hovered slot = ",hovered_slot)

func _drag_start(arg1):
	dragged_item = arg1
	dragged_item_index = extract_number_from_node_name(str(arg1.get_parent()))-1
	drag_start_slot = hovered_slot
	print("drag start = ", dragged_item, " ", dragged_item_index)

func _drag_stop(arg1):
	print("drag stopped")

	# Ensure hovered_slot and dragged_item are valid
	if hovered_slot != null and dragged_item:
		print(Inv, Inv[hovered_slot_index], hovered_slot)
		# Check if the target slot is empty
		
		print("Before swap - hovered_slot:", hovered_slot, "dragged_item:", dragged_item)
		
		# Swap items in inventory
		var temp = Inv[hovered_slot_index]
		
		Inv[hovered_slot_index] = Inv[dragged_item_index]
		Inv[dragged_item_index] = temp
		
		# Print inventory state
		print("After swap - Inv:", Inv)

		# Reparent item in UI (if applicable)
		if dragged_item:
			dragged_item.reparent(hovered_slot)
			print("Reparented item to slot:", hovered_slot)
			center_node_in_parent(dragged_item, hovered_slot)
	

	elif hovered_slot == null:
		center_node_in_parent(dragged_item, drag_start_slot)
		print("Invalid hovered_slot or dragged_item:", hovered_slot, dragged_item)
	
	# Reset the dragged_item reference
	dragged_item = null
	#hovered_slot = null
	
	
	
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

func center_node_in_parent(child_node, parent_node):
	if child_node and parent_node:
		# Get the size of the parent and child nodes
		var parent_size = parent_node.size
		var child_size = child_node.size
		
		# Calculate the center position for the child node
		var new_position = (parent_size - child_size) / 2
		
		# Set the child's position to the new center position
		child_node.position = new_position
		print("Child node reparented and centered")
	else:
		print("Invalid child node or parent node")
