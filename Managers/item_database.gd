extends Node

var items = Array()
# Called when the node enters the scene tree for the first time.
func _ready():
	var directory = DirAccess.open("res://Items")
	directory.list_dir_begin()
	
	var filename = directory.get_next()
	while(filename):
		if not directory.current_is_dir():
			items.append(load("res://Items/%s" % filename))
			
		
		filename = directory.get_next()
		
func get_item(item_name):
	for i in items:
		if i.name == item_name:
			return i
	
	return null


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
