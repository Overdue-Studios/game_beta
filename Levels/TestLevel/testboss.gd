extends CharacterBody2D

@export var health = 100
@export var speed = 50
@onready var hp_bar = $TextureProgressBar
@onready var animation_player = get_node("AnimatedSprite2D")
@onready var ray = $RayCast2D
@onready var state = State.IDLE

enum State { IDLE, ATTACK_MELEE, ATTACK_RANGED, AOE_STOMP, AGGRO }

func _ready():
	hp_bar.max_value = health
	var weapon = get_parent().get_node("Player")
	weapon.connect("damage_dealt", Callable(self, "_took_damage"))
	animation_player.play("default")

func _physics_process(delta):
	if Engine.get_frames_drawn() % 1 == 0:
		ray.target_position = get_parent().get_node("Player").global_position - self.global_position
		
		if ray.get_collider() == get_parent().get_node("Player") and ray.target_position.length() < 160:
			print("gayyyyy")
		
		match state:
			State.IDLE:
				if ray.get_collider() == get_parent().get_node("Player") and ray.target_position.length() < 160:
					print("IDLE")
					transition_to(State.AGGRO)
			State.AGGRO:
				print("AGGRO")
				if ray.get_collider() == get_parent().get_node("Player") and ray.target_position.length() < 30:
					transition_to(State.AOE_STOMP)
				elif ray.get_collider() == get_parent().get_node("Player") and ray.target_position.length() < 50:
					transition_to(State.ATTACK_MELEE)
				elif ray.get_collider() == get_parent().get_node("Player") and ray.target_position.length() < 140:
					transition_to(State.ATTACK_RANGED)
			State.AOE_STOMP:
				print("STOMP")
				transition_to(State.AGGRO)
			State.ATTACK_MELEE:
				print("MELEE")
				velocity.x =  speed
				print(self.global_position.direction_to(get_parent().get_node("Player").global_position))

			State.ATTACK_RANGED:
				print("RANGED")
				transition_to(State.AGGRO)
	move_and_slide()
	velocity = Vector2(0,0)
				
func connect_to_signal_in_tree(tree: String, signal_name: String, method_name: String):
	print("Connected")
	var nodes = get_tree().get_nodes_in_group(tree)
	for node in nodes:
		if node.has_signal(signal_name):
			node.connect(signal_name, Callable(self, method_name))

func _took_damage(damage, body):
	if self.get_node("Dragon") == body:
		print("Took damage")
		health -= damage
		hp_bar.value = health
		$Dragon/AnimatedSprite2D.modulate = Color.RED
		await get_tree().create_timer(0.1).timeout
		$Dragon/AnimatedSprite2D.modulate = Color.WHITE
		if hp_bar.value <= 0:
			self.queue_free()
			
func transition_to(new_state):
	state = new_state
