extends CharacterBody2D

@export var speed = 70
@export var jump_speed = 1800
@export var gravity = 4000
@export var hp : int = 200
@export var max_hp : int = 200
@export var fp : int = 100
@export var max_fp : int = 100
@export var stam : int = 300
@export var max_stam : int = 300

@onready var animation_player = $AnimatedSprite2D
@onready var primary_hitbox = $PrimaryAttack
@onready var secondary_hitbox = $SecondaryAttack
@onready var state = State.IDLE
@onready var hp_bar = %PlayerHP
@onready var fp_bar = %PlayerFP
@onready var stam_bar = %PlayerSTAM

enum State { IDLE, RUNNING, JUMPING, FALLING, ATTACKING_1, ATTACKING_2, ROLL, DIE }

signal primary_action
signal secondary_action
signal damage_dealt

var inventory_resource = load("res://Player/Inventory/inventory.gd")
var inventory = inventory_resource.new()
var weapon_damage = 1
var tab_inventory = load("res://Player/Inventory/TabInventory.tscn")
var inventory_open = false

func _ready():
	hp_bar.max_value = max_hp
	fp_bar.max_value = max_fp
	stam_bar.max_value = max_stam
	hp_bar.value = hp
	fp_bar.value = fp
	stam_bar.value = stam
	primary_hitbox.position.x = 13.5
	secondary_hitbox.position.x = 10.5
	
func _physics_process(_delta):
	if stam < max_stam:
		stam += 1 
		stam_bar.value = stam
	velocity.y += gravity * _delta
	if hp <= 0:
		transition_to(State.DIE)
	if GameManager.nomove == false:
		velocity.x = Input.get_axis("ui_left", "ui_right") * speed
		match state:
			State.DIE:
				if animation_player.frame == 3:
					animation_player.pause()
					await get_tree().create_timer(1).timeout
					self.visible = false
					self.process_mode = Node.PROCESS_MODE_DISABLED
			State.IDLE:
				if velocity.x != 0:
					transition_to(State.RUNNING)
				elif !is_on_floor():
					transition_to(State.FALLING)
				elif Input.is_action_just_pressed("primary_action") and stam >= 25:
					transition_to(State.ATTACKING_1)
				elif Input.is_action_just_pressed("secondary_action") and stam >= 45:
					transition_to(State.ATTACKING_2)
				elif Input.is_action_just_pressed("roll"):
					transition_to(State.ROLL)
			State.RUNNING:
				if velocity.x > 0:
					animation_player.flip_h = false
					primary_hitbox.position.x = 13.5
					secondary_hitbox.position.x = 10.5
				elif velocity.x < 0:
					animation_player.flip_h = true
					primary_hitbox.position.x = -13.5
					secondary_hitbox.position.x = -10.5
				if velocity.x == 0:
					transition_to(State.IDLE)
				if !is_on_floor():
					transition_to(State.JUMPING)
				elif Input.is_action_just_pressed("primary_action") and stam >= 25:
					transition_to(State.ATTACKING_1)
				elif Input.is_action_just_pressed("secondary_action") and stam >= 45:
					transition_to(State.ATTACKING_2)
				elif Input.is_action_just_pressed("roll"):
					transition_to(State.ROLL)
			State.JUMPING:
				if velocity.x > 0:
					animation_player.flip_h = false
					primary_hitbox.position.x = 13.5
					secondary_hitbox.position.x = 10.5
				elif velocity.x < 0:
					animation_player.flip_h = true
					primary_hitbox.position.x = -13.5
					secondary_hitbox.position.x = -10.5
				if is_on_floor():
					transition_to(State.IDLE)
				elif Input.is_action_just_pressed("primary_action") and stam >= 25:
					transition_to(State.ATTACKING_1)
				elif Input.is_action_just_pressed("secondary_action") and stam >= 45:
					transition_to(State.ATTACKING_2)
				elif Input.is_action_just_pressed("roll"):
					transition_to(State.ROLL)
			State.FALLING:
				if velocity.x > 0:
					animation_player.flip_h = false
					primary_hitbox.position.x = 13.5
					secondary_hitbox.position.x = 10.5
				elif velocity.x < 0:
					animation_player.flip_h = true
					primary_hitbox.position.x = -13.5
					secondary_hitbox.position.x = -10.5
				if is_on_floor():
					transition_to(State.IDLE)
				elif Input.is_action_just_pressed("primary_action") and stam >= 25:
					transition_to(State.ATTACKING_1)
				elif Input.is_action_just_pressed("secondary_action") and stam >= 45:
					transition_to(State.ATTACKING_2)
				elif Input.is_action_just_pressed("roll"):
					transition_to(State.ROLL)
			State.ATTACKING_1:
				if Input.is_action_just_pressed("roll"):
					transition_to(State.ROLL)
				if animation_player.frame == 3:
					stam -= 25
					stam_bar.value = stam
					primary_hitbox.monitoring = true
				if animation_player.frame == 4:
					primary_hitbox.monitoring = false
				if animation_player.frame == 7:
					transition_to(State.IDLE)
			State.ATTACKING_2:
				if Input.is_action_just_pressed("roll"):
					transition_to(State.ROLL)
				if animation_player.frame == 3:
					stam -= 45
					stam_bar.value = stam
					secondary_hitbox.monitoring = true
				if animation_player.frame == 9:
					secondary_hitbox.monitoring = false
				if animation_player.frame == 11:
					transition_to(State.IDLE)
			State.ROLL:
				velocity.y = 0
				if animation_player.flip_h == true:
					velocity.x = -200
				else:
					velocity.x = 200
				if animation_player.frame == 5:
					transition_to(State.IDLE)
					
	move_and_slide()
	if Input.is_action_just_pressed("interact"):
		var dream = get_tree().get_nodes_in_group("dream")
		for i in dream:
			if i.visible == false:
				i.process_mode = Node.PROCESS_MODE_INHERIT
				i.visible = true
			else:
				i.process_mode = Node.PROCESS_MODE_DISABLED
				i.visible = false
		
	if Input.is_action_just_pressed("ui_up") and GameManager.nomove == false and is_on_floor() == true:
		velocity.y = -jump_speed
		transition_to(State.JUMPING)
	
func _process(_delta):
	if Input.is_action_just_pressed("primary_action") and stam >= 25:
		primary_action.emit()
		
	if Input.is_action_just_pressed("secondary_action") and stam >= 45:
		secondary_action.emit()
	
	#Inventory opener, spawna novga otroka UI scene
	if Input.is_action_just_pressed("inventory"):
		get_tree().paused = true
		inventory_open = true
		var tab_inventory_ui = tab_inventory.instantiate()
		add_child(tab_inventory_ui)
		GameManager.nomove = true
		
func transition_to(new_state):
	state = new_state
	match new_state:
		State.DIE:
			animation_player.play("die")
		State.IDLE:
			animation_player.play("idle")
		State.RUNNING:
			animation_player.play("running")
		State.JUMPING:
			animation_player.play("jump")
		State.FALLING:
			animation_player.play("fall")
		State.ATTACKING_1:
			animation_player.play("primary_attack")
		State.ATTACKING_2:
			animation_player.play("secondary_attack")
		State.ROLL:
			animation_player.play("roll")

func _on_primary_attack_body_entered(body: Node2D) -> void:
	if body != self:
		GameManager.hit_stop(0.12)
		print("hit with primary:", body)
		emit_signal("damage_dealt", 15, body)
		


func _on_secondary_attack_body_entered(body: Node2D) -> void:
	if body != self:
		print("hit with 2ndary:", body)
		emit_signal("damage_dealt", 30, body)
