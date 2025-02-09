extends Node

signal player_initialised
var player
var nomove = false
var console_open = false
@onready var console
func _process(_delta):
	if not player:
		initialise_player()
		return
		
	if Input.is_action_just_pressed("save"):
		save("save1")
	
	if Input.is_action_just_pressed("load_save"):
		load_save("save1")
	

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

func hit_stop(time:float):
	Engine.time_scale = 0
	await get_tree().create_timer(time, true, false, true).timeout
	Engine.time_scale = 1


func save(save_name):
	var config = ConfigFile.new()
	config.set_value("Player", "position", player.position)
	config.set_value("Player", "hp", player.hp)
	config.set_value("Player", "level", get_tree().get_current_scene().get_scene_file_path())
	config.save("user://%s.cfg" % str(save_name))
	
func load_save(save_name):
	# Load data from a file.
	var config = ConfigFile.new()
	var err = config.load("user://%s.cfg" % str(save_name))	

	# If the file didn't load, ignore it.
	if err != OK:
		return
	await get_tree().change_scene_to_file(config.get_value("Player", "level"))
	await get_tree().process_frame  # Wait for one frame to ensure scene is loaded
	await get_tree().create_timer(0.1).timeout  # Add small delay to ensure everything is initialized
	initialise_player()
	player.hp = config.get_value("Player", "hp")
	player.position = config.get_value("Player", "position")
	get_tree().get_root().get_node("/root/map_root/BossCam").priority = 1
	player.hp_bar.value = config.get_value("Player", "hp")
	
	
