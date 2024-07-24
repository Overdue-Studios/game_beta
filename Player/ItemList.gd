extends ItemList



# Called when the node enters the scene tree for the first time.
func _ready():
	var player = get_tree().get_root().get_node("/root/map_root/Player")
	GameManager.connect("player_initialised", Callable(self,"_on_player_initialised"))
	print(player.inventory.get_items())
	player.inventory.connect("inventory_changed", Callable(self, "_on_player_inventory_changed"))
	for item in player.inventory.get_items():
		add_item("%s x%d" % [item.item_reference.name, item.quantity])
		
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

