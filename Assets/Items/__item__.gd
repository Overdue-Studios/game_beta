class_name Item extends Node

@export var item_name: String = "Item"
@export var max_quantity: int = 5
@export var quantity: int = 5

func use_item():
	if self.quantity <= 0:
		self.quantity = 0
		return
	self.quantity -= 1

func pickup_item():
	if self.quantity >= self.max_quantity:
		self.quantity = self.max_quantity
		return
	self.quantity += 1
