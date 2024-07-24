extends PanelContainer

@onready var InvSlots = get_node("SlotContainer").get_children()
# Called when the node enters the scene tree for the first time.
func _ready():
	var player = get_tree().get_root().get_node("/root/map_root/Player")
	
	
	GameManager.connect("player_initialised", Callable(self,"_on_player_initialised"))
	
	var Inv = player.inventory.get_items()
	print(Inv)
	player.inventory.connect("inventory_changed", Callable(self, "_on_player_inventory_changed"))
	for i in range(Inv.size()-1):
		if Inv[i] != null:
			
			#var item = ItemDatabase.get_item(Inv[i].name)
			#print(InvSlots[i].get_children())
			InvSlots[i].get_children()[0].texture = Inv[i].item_reference.texture
			InvSlots[i].get_children()[1].text = str(Inv[i].quantity)
			InvSlots[i].get_children()[2].get_children()[0].text = Inv[i].item_reference.name
		
		
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
