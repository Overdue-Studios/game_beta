extends Node

signal player_initialised
var player
var nomove = false
func _process(_delta):
	if not player:
		initialise_player()
		return

func initialise_player():
	player = get_tree().get_root().get_node("/root/map_root/Player")
	if not player:
		return
		
	emit_signal("player_initialised", player)
	
	player.inventory.connect("inventory_changed", Callable(self, "_on_player_inventory_changed"))
	
	var existing_inventory = load("user://inventory.tres")
	if existing_inventory:
		player.inventory.set_items(existing_inventory.get_items())
		player.inventory.add_item("Sheckel", 3)
	
	
func _on_player_inventory_changed(inventory):
	ResourceSaver.save(player.inventory, "user://inventory.tres")
