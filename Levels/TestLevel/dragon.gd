extends Node2D

@export var health = 100
@onready var hp_bar = $TextureProgressBar
@onready var animation_player = get_node("Dragon/AnimatedSprite2D")

enum states { IDLE, ATTACK_MELEE, ATTACK_RANGED }

func _ready():
	hp_bar.max_value = health
	var weapon = get_parent().get_node("Player")
	weapon.connect("damage_dealt", Callable(self, "_took_damage"))
	animation_player.play("default")

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
		hp_bar.value = health
		$Dragon/AnimatedSprite2D.modulate = Color.RED
		await get_tree().create_timer(0.1).timeout
		$Dragon/AnimatedSprite2D.modulate = Color.WHITE
		if hp_bar.value <= 0:
			self.queue_free()

func _on_area_2d_body_entered(body: Node2D) -> void:
	print("Alert")


func _on_area_2d_body_exited(body: Node2D) -> void:
	print("Calm")
