extends GridContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	GameManager.connect("player_initialised", Callable(self,"_on_player_initialised"))

func _on_player_initialised(player):
	player.inventory.connect("inventory_changed", Callable(self, "_on_player_inventory_changed"))

func _on_player_inventory_changed(inventory):
	for n in get_children():
		n.queue_free()
		
	for item in inventory.get_items():
		var item_label = Label.new()
		item_label.text = "%s x%d" % [item.item_reference.name, item.quantity]
		add_child(item_label)
