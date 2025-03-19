extends CharacterBody2D
@export var gravity : int = 2500
@export var health : int = 200
@export var speed = 500
@export var attack_range = 160
@onready var hp_bar = get_parent().get_node("BossCam/BossHP")
@onready var nametxt = get_parent().get_node("BossCam/Label")
@onready var animation_player = $AnimatedSprite2D
@onready var ray = $RayCast2D
@onready var melee_attack_range = 50
@onready var camera = %Camera2D
@onready var current_mob_state = State.IDLE
@onready var player = GameManager.player
@onready var fireball = preload("res://Levels/TestLevel/Entities/fireball.tscn")
@onready var stagger_count = 0

enum State { IDLE, ATTACK_MELEE, ATTACK_RANGED, AGGRO, HIT, DEATH, FLEE }

func _ready():
	player.connect("damage_dealt", Callable(self, "_took_damage"))
	animation_player.play("idle")
	hp_bar.max_value = health
	hp_bar.value = health

func _process(_delta : float) -> void:
	velocity.y += gravity * _delta
		
	if Engine.get_frames_drawn() % 1 == 0:
		match current_mob_state:
			#State.IDLE:
				#idle stuff
			State.AGGRO:
				hp_bar.visible = true
				nametxt.visible = true
				var direction_to_player = (player.global_position - global_position).normalized()
				var distance_to_player = (player.global_position - global_position).length()
				ray.target_position = direction_to_player * distance_to_player

				if ray.get_collider() == player:
					if ray.target_position.length() > (melee_attack_range * 2):
						transition_to(State.ATTACK_RANGED)
					elif ray.target_position.length() > melee_attack_range:
						if self.global_position.direction_to(player.global_position).x < 0:
							velocity.x = -speed
							animation_player.flip_h = false
							$Area2D.scale = Vector2(1,1)
						else:
							velocity.x = speed
							animation_player.flip_h = true
							$Area2D.scale = Vector2(-1,1)
					else:
						transition_to(State.ATTACK_MELEE)
			State.ATTACK_RANGED:
				if not get_parent().get_node("Fireball"):
					_cast_fireball()
				#await get_tree().create_timer(2).timeout
				transition_to(State.AGGRO)
			State.ATTACK_MELEE:
				if animation_player.frame == 9:
					GameManager.hit_stop(0.18)
					#camera.shake(1, 0.1)
					#TODO: Ask matty show the "Phanton Camera works and 
				if animation_player.frame == 9:
					$Area2D.monitoring = true
				if animation_player.frame == 10:
					$Area2D.monitoring = false
				if animation_player.frame == 14:
					transition_to(State.AGGRO)
			State.DEATH:
				if animation_player.frame == 21:
					hp_bar.visible = false
					nametxt.visible = false
					emit_signal("dead")
					self.queue_free()
			State.HIT:
				if animation_player.frame == 4:
					transition_to(State.AGGRO)
			State.FLEE:
				if ray.get_collider() == player and ray.target_position.length() < 60:
					if self.global_position.direction_to(player.global_position).x < 0:
						velocity.x = speed *3
						animation_player.flip_h = false
					else: 
						velocity.x = -speed *3
						animation_player.flip_h = true
				if animation_player.frame == 11:
					stagger_count = 0
					transition_to(State.AGGRO)
					
	move_and_slide()

	if is_on_floor():
		velocity = Vector2(0,0)

func connect_to_signal_in_tree(tree: String, signal_name: String, method_name: String):
	var nodes = get_tree().get_nodes_in_group(tree)
	for node in nodes:
		if node.has_signal(signal_name):
			node.connect(signal_name, Callable(self, method_name))

func _took_damage(damage, body):
	if self == body and current_mob_state != State.DEATH:
		if stagger_count < 2:
			stagger_count += 1
			health -= damage
			hp_bar.value = health
			if current_mob_state != State.ATTACK_RANGED:
				transition_to(State.HIT)
		else:
			transition_to(State.FLEE)
		
		if hp_bar.value <= 0:
			transition_to(State.DEATH)
			
func _cast_fireball():
	var fireball_position = self.global_position
	fireball_position.y -= 25
	var fire_b = fireball.instantiate()
	get_parent().add_child(fire_b)
	fire_b.global_position = fireball_position
	fire_b._init_node(player)

func transition_to(new_state):
	current_mob_state = new_state
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
		State.FLEE:
			animation_player.play("flee")


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body == player:
		player.damage(30)


func _on_area_2d_2_body_entered(body: Node2D) -> void:
	if body == player:
		player.damage(30)
		player.knocked = true

#This function triggers when the player collides with the door to the boss room thus triggering the boss fight.
func _on_door_right_body_entered(body:Node2D) -> void:
	if body == player && current_mob_state == State.IDLE:
		emit_signal("aggro")
		transition_to(State.AGGRO)
		print("Player entered go aggro")
