extends Node

signal player_initialised
var player
var camera
var main
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
	player = get_tree().get_root().get_node("/root/Main/Player")
	camera = get_tree().get_root().get_node("/root/Main/Player_Camera")
	main = get_tree().get_root().get_node("/root/Main")
	print(player)
	if not player:
		return
	print("player initialised")
	
	emit_signal("player_initialised", player)

func hit_stop(time:float):
	Engine.time_scale = 0
	await get_tree().create_timer(time, true, false, true).timeout
	Engine.time_scale = 1


func save(save_name):
	var config = ConfigFile.new()
	config.set_value("Player", "position", player.position)
	config.set_value("Player", "hp", player.hp)
	config.set_value("Player", "level", main.level)
	config.save("user://%s.cfg" % str(save_name))
	
func load_save(save_name):
	# Load data from a file.
	var config = ConfigFile.new()
	var err = config.load("user://%s.cfg" % str(save_name))	

	# If the file didn't load, create a new save
	if err != OK:
		save(save_name)
		return
		
	main.load_level()
	await get_tree().process_frame  # Wait for one frame to ensure scene is loaded
	await get_tree().create_timer(0.1).timeout  # Add small delay to ensure everything is initialized
	player.hp = config.get_value("Player", "hp")
	player.position = config.get_value("Player", "position")
	player.hp_bar.value = config.get_value("Player", "hp")
	
