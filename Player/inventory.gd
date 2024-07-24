extends Node

signal inventory_changed

@export var _items = Array() : set = set_items, get = get_items

func set_items(new_items):
	_items = new_items
	emit_signal("inventory_changed", self)
	
func get_items():
	return _items
	

func get_item(index):
	return _items[index]
	
func remove_item(item_name, quantity):
	if quantity <= 0:
		print("Can't remove negative number of items")
		return
	
	var item = ItemDatabase.get_item(item_name)
	if not item:
		print("Could not find item to remove")
		return
	var item_quantity = 0
	for i in range(_items.size()):
		
		var inventory_item = _items[i]
		if inventory_item.item_reference.name != item.name:
			continue
		item_quantity += inventory_item.quantity
			
	if item_quantity < quantity:
		print("Not enough items to remove")
		return
	
	var remaining_quantity = quantity
	var max_stack_size = item.max_stack_size if item.stackable else 1
	
	for i in range(_items.size()):
		if remaining_quantity == 0:
			break
		
		var inventory_item = _items[i]
		if inventory_item.item_reference.name != item.name:
			continue
			
		var original_quantity = inventory_item.quantity
		inventory_item.quantity = max(original_quantity - remaining_quantity, 0)
		remaining_quantity -= abs(inventory_item.quantity - original_quantity)
		
		if inventory_item.quantity == 0:
			_items.remove_at(i)
			
	emit_signal("inventory_changed", self)
	
func add_item(item_name, quantity):
	_items.resize(35)
	if quantity <= 0:
		print("Can't add negative number of items")
		return
	print(item_name)
	var item = ItemDatabase.get_item(item_name)
	if not item:
		print("Could not find item")
		return
	
	var remaining_quantity = quantity
	var max_stack_size = item.max_stack_size if item.stackable else 1
	
	if item.stackable:
		for i in range(_items.size()):
			if remaining_quantity == 0:
				break
			
			var inventory_item = _items[i]
			if inventory_item == null or inventory_item.item_reference.name != item.name:
				continue
			
			if inventory_item.quantity < max_stack_size:
				var original_quantity = inventory_item.quantity
				inventory_item.quantity = min(original_quantity + remaining_quantity, max_stack_size)
				remaining_quantity -= inventory_item.quantity - original_quantity
	
	while remaining_quantity > 0: #20
		var index_num = 0 #[x, null, y, null]
		
		for i in range(_items.size()):
			if _items[i] == null:
				index_num = i
				break
			
			
		var new_item = {
			slot = index_num,
			item_reference = item,
			quantity = min(remaining_quantity, max_stack_size)
		}
		_items.insert(index_num, new_item)
		remaining_quantity -= new_item.quantity
		
	emit_signal("inventory_changed", self)
