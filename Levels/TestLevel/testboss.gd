extends CharacterBody2D
@export var gravity = 2500
@export var health = 100
@export var speed = 50
@onready var hp_bar = get_parent().get_node("BossCam/BossHP")
@onready var nametxt = get_parent().get_node("BossCam/Label")
@onready var animation_player = $AnimatedSprite2D
@onready var ray = $RayCast2D
@onready var state = State.IDLE
@onready var player = get_parent().get_node("Player")

enum State { IDLE, ATTACK_MELEE, AGGRO, HIT, DEATH }

func _ready():#
	animation_player.play("idle")
	hp_bar.max_value = health
	hp_bar.value = health
	player.connect("damage_dealt", Callable(self, "_took_damage"))
	animation_player.play("default")

func _physics_process(_delta):
	velocity.y += gravity * _delta
	if Engine.get_frames_drawn() % 1 == 0:
		ray.target_position = get_parent().get_node("Player").global_position - self.global_position
		
		match state:
			State.IDLE:
				if ray.get_collider() == get_parent().get_node("Player") and ray.target_position.length() < 160:
					print("IDLE")
					transition_to(State.AGGRO)
			State.AGGRO:
				hp_bar.visible = true
				nametxt.visible = true
				print("AGGRO")
				print(ray.target_position.length())
				if ray.get_collider() == get_parent().get_node("Player") and ray.target_position.length() > 50:
					if self.global_position.direction_to(get_parent().get_node("Player").global_position).x < 0:
						velocity.x = -speed
						animation_player.flip_h = false
					else: 
						velocity.x = speed
						animation_player.flip_h = true
				else:
					transition_to(State.ATTACK_MELEE)
					
			State.ATTACK_MELEE:
				if animation_player.frame == 14:
					transition_to(State.AGGRO)
			State.DEATH:
				if animation_player.frame == 21:
					hp_bar.visible = false
					nametxt.visible = false
					self.queue_free()
			State.HIT:
				if animation_player.frame == 4:
					transition_to(State.AGGRO)
					
	move_and_slide()
	if is_on_floor():
		velocity = Vector2(0,0)
				
func connect_to_signal_in_tree(tree: String, signal_name: String, method_name: String):
	print("Connected")
	var nodes = get_tree().get_nodes_in_group(tree)
	for node in nodes:
		if node.has_signal(signal_name):
			node.connect(signal_name, Callable(self, method_name))

func _took_damage(damage, body):
	if self == body and state != State.DEATH:
		transition_to(State.HIT)
		health -= damage
		hp_bar.value = health
		
		if hp_bar.value <= 0:
			transition_to(State.DEATH)
			
func transition_to(new_state):
	state = new_state
	match new_state:
		State.IDLE:
			animation_player.play("idle")
		State.AGGRO:
			animation_player.play("walk")
		State.ATTACK_MELEE:
			animation_player.play("attack")
		State.DEATH:
			animation_player.play("death")
		State.HIT:
			animation_player.play("hit")
