extends Node2D

@export var health = 100

func _ready():
	var weapon = get_parent().get_node("Player")
	weapon.connect("damage_dealt", Callable(self, "_took_damage"))

func _process(delta):
	pass

func connect_to_signal_in_tree(tree: String, signal_name: String, method_name: String):
	print("Connected")
	var nodes = get_tree().get_nodes_in_group(tree)
	for node in nodes:
		if node.has_signal(signal_name):
			node.connect(signal_name, Callable(self, method_name))

func _took_damage(damage, body):
	#print("Self: ", self.get_node("Dragon"))
	#print("Body: ", body)
	if self.get_node("Dragon") == body:
		print("Took damage")
		health -= damage
		print(self, health)

func _on_area_2d_body_entered(body: Node2D) -> void:
	print("Alert")


func _on_area_2d_body_exited(body: Node2D) -> void:
	print("Calm")
