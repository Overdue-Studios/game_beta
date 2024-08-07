extends Node2D

@export var health = 100

enum States {
	STATE_IDLE,
	STATE_RANGED,
	STATE_MELEE,
	STATE_WAIT
	}

# Called when the node enters the scene tree for the first time.
func _ready():
	connect_to_signal_in_tree("Weapons" ,"damage_dealt", "_took_damage")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func connect_to_signal_in_tree(tree: String, signal_name: String, method_name: String):
	var nodes = get_tree().get_nodes_in_group(tree)
	for node in nodes:
		if node.has_signal(signal_name):
			node.connect(signal_name, Callable(self, method_name))
			
func _took_damage(body, damage):
	if self == body:
		health -= damage
		print(self, health)
