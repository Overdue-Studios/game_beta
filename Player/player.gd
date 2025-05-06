extends CharacterBody2D

@export var stamina_regen_time : float = 2
@export var stamina_regen_speed :float = 1
@export var speed = 100
@export var jump_speed = 320
@export var gravity = 1500
@export var hp : int = 200
@export var max_hp : int = 200
@export var fp : int = 100
@export var max_fp : int = 100
@export var max_stam : int = 300
@export var climbing = false
@export var fast_drop_multiplier : float = 5.0
@export var roll_speed : float = 5.0
@export var fall_dmg_multiplier : float = 0.1

@onready var knocked = false
@onready var animation_player = $AnimatedSprite2D
@onready var primary_hitbox = $PrimaryAttack
@onready var secondary_hitbox = $SecondaryAttack
@onready var state = State.IDLE
@onready var hp_bar = %PlayerHP
@onready var fp_bar = %PlayerFP
@onready var stam_bar = %PlayerSTAM
@onready var stam_cd = 0
@onready var stam_used = false
@onready var door = $"../StaticBody2D/AnimationPlayer"

enum State { IDLE, RUNNING, JUMPING, FALLING, ATTACKING_1, ATTACKING_2, ATTACK_FALLING, ROLL, DIE, KNOCKBACK }

signal primary_action
signal secondary_action
signal damage_dealt

var weapon_damage = 1
var can_double_jump = false
var healingFlask
var manaFlask
var last_speed = 0

func _ready():
	hp_bar.max_value = max_hp
	fp_bar.max_value = max_fp
	stam_bar.max_value = max_stam
	stam_bar.value = max_stam
	hp_bar.value = hp
	fp_bar.value = fp
	primary_hitbox.position.x = 13.5
	secondary_hitbox.position.x = 10.5
	healingFlask = HealingFlask.new()
	manaFlask = ManaFlask.new()
	
func _process(_delta):
	# Knockback logic
	if Input.is_action_pressed("primary_action") and stam_bar.value >= 25:
		primary_action.emit()
		
	if Input.is_action_just_pressed("heal"):
		print("Restoring HP: " + str(self.hp) + " " + str(healingFlask.quantity))
		healingFlask.use_flask(self)
		
	if Input.is_action_just_pressed("fpheal"):
		print("Restoring Mana: " + str(self.fp) + " " + str(manaFlask.quantity))
		manaFlask.use_flask(self)

	if Input.is_action_pressed("secondary_action") and stam_bar.value >= 45:
		secondary_action.emit()
	if knocked == true:
		if self.global_position.direction_to(get_parent().get_node("Dragon").global_position).x < 0:
			velocity.x += 200
		else:
			velocity.x -= 200
		knocked = false
		transition_to(State.KNOCKBACK)

	# Gravity
	#velocity.y += gravity * _delta
	
	# Stamina cooldown
	if Input.is_action_pressed("ui_down"):
		velocity.y += speed * _delta * fast_drop_multiplier
	
	if stam_cd > 0:
		stam_cd -= _delta
	elif stam_cd <= 0:
		stam_bar.value += stamina_regen_speed
		
	# Climbing code, if bool is true then only check Y coord movement, else run the normal state machine
	if climbing:
		velocity.y = Input.get_axis("ui_up", "ui_down") * speed
	else:
		velocity.y += gravity * _delta
		
	# Dying
	if hp <= 0:
		transition_to(State.DIE)
	
	# Horizontal movement if not knocked
	if GameManager.nomove == false:
		if state != State.KNOCKBACK:
			velocity.x = Input.get_axis("ui_left", "ui_right") * speed
			
		# --- State Machine ---
		match state:
			State.KNOCKBACK:
				if animation_player.frame == 3:
					velocity.x = 0
					transition_to(State.IDLE)
			State.DIE:
				if animation_player.frame == 2:
					animation_player.pause()
					await get_tree().create_timer(1).timeout
					self.visible = false
					self.process_mode = Node.PROCESS_MODE_DISABLED
					get_tree().paused = true
			State.IDLE:
				if velocity.x != 0:
					transition_to(State.RUNNING)
				elif !is_on_floor():
					transition_to(State.FALLING)
				elif Input.is_action_just_pressed("primary_action") and stam_bar.value >= 25:
					transition_to(State.ATTACKING_1)
				elif Input.is_action_just_pressed("secondary_action") and stam_bar.value >= 45:
					transition_to(State.ATTACKING_2)
				elif Input.is_action_just_pressed("roll") and stam_bar.value >= 15:
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
				elif Input.is_action_just_pressed("primary_action") and stam_bar.value >= 25:
					transition_to(State.ATTACKING_1)
				elif Input.is_action_just_pressed("secondary_action") and stam_bar.value >= 45:
					transition_to(State.ATTACKING_2)
				elif Input.is_action_just_pressed("roll") and stam_bar.value >= 15:
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
				elif Input.is_action_just_pressed("primary_action") and stam_bar.value >= 25:
					transition_to(State.ATTACKING_1)
				elif Input.is_action_just_pressed("secondary_action") and stam_bar.value >= 45:
					transition_to(State.ATTACKING_2)
				elif Input.is_action_just_pressed("roll") and stam_bar.value >= 15:
					transition_to(State.ROLL)
				else:
					transition_to(State.FALLING)
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
					can_double_jump = false
					print("floor")	
					#Fall Damage calc
					if(last_speed > 450):
						damage((last_speed - 450) * fall_dmg_multiplier)
					transition_to(State.IDLE)
				elif Input.is_action_just_pressed("primary_action") and stam_bar.value >= 25:
					transition_to(State.ATTACK_FALLING)
				elif Input.is_action_just_pressed("secondary_action") and stam_bar.value >= 45:
					transition_to(State.ATTACKING_2)
				elif Input.is_action_just_pressed("roll") and stam_bar.value >= 15:
					transition_to(State.ROLL)
			State.ATTACKING_1:
				if Input.is_action_just_pressed("roll") and stam_bar.value >= 15:
					transition_to(State.ROLL)
				if animation_player.frame == 3:
					if stam_used == false:
						use_stamina(25)
						stam_used = true
					primary_hitbox.monitoring = true
				if animation_player.frame == 4:
					primary_hitbox.monitoring = false
				if animation_player.frame == 7:
					transition_to(State.IDLE)
			State.ATTACKING_2:
				if Input.is_action_just_pressed("roll") and stam_bar.value >= 15:
					transition_to(State.ROLL)
				if animation_player.frame == 3:
					if stam_used == false:
						use_stamina(45)
						stam_used = true
					secondary_hitbox.monitoring = true
				if animation_player.frame == 9:
					secondary_hitbox.monitoring = false
				if animation_player.frame == 11:
					transition_to(State.IDLE)
			State.ATTACK_FALLING:
				if is_on_floor():
					transition_to(State.IDLE)
				velocity.x = 0
				velocity.y += speed * _delta * fast_drop_multiplier
			State.ROLL:
				if stam_used == false:
						use_stamina(15)
						stam_used = true
				for i in range(1,4):
					if animation_player.frame == i:
						velocity.x *= roll_speed - i
				if animation_player.frame == 5:
					transition_to(State.IDLE)
					
	move_and_slide()
	if(velocity.y): last_speed = velocity.y
	# Interact group toggle
	if Input.is_action_just_pressed("interact"):
		var dream = get_tree().get_nodes_in_group("dream")
		for i in dream:
			if i.visible == false:
				i.process_mode = Node.PROCESS_MODE_INHERIT
				i.visible = true
			else:
				i.process_mode = Node.PROCESS_MODE_DISABLED
				i.visible = false
		
	# Double jump logic
	if Input.is_action_just_pressed("ui_up") and GameManager.nomove == false:
		# First jump (on floor)
		if is_on_floor():
			velocity.y = -jump_speed
			can_double_jump = true
			transition_to(State.JUMPING)
		# Second jump (in air)
		elif can_double_jump:
			velocity.y = -jump_speed
			can_double_jump = false
			transition_to(State.JUMPING)
			
func transition_to(new_state):
	state = new_state
	match new_state:
		State.DIE:
			animation_player.play("die")
		State.IDLE:
			stam_used = false
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
		State.ATTACK_FALLING:
			animation_player.play("attack_fall")
		State.ROLL:
			animation_player.play("roll")
		State.KNOCKBACK:
			animation_player.play("die")

func _on_primary_attack_body_entered(body: Node2D) -> void:
	if body != self:
		GameManager.hit_stop(0.12)
		emit_signal("damage_dealt", 15, body)
		
func _on_secondary_attack_body_entered(body: Node2D) -> void:
	if body != self:
		print("hit with 2ndary:", body)
		emit_signal("damage_dealt", 30, body)

func damage(amount):
	$AnimatedSprite2D/BloodParticles.emitting = true
	var mat = $AnimatedSprite2D.material as ShaderMaterial
	mat.set_shader_parameter("whiteout", 1.0)
	var fade_time := 1.0
	await get_tree().create_timer(fade_time/2).timeout
	var timer := 0.0
	while timer < fade_time:
		await get_tree().process_frame
		timer += get_process_delta_time()*3
		#var size = 1.0 if timer <= fade_time/2 else 1.0 - (timer / fade_time)
		var size = 1.0 - (timer / fade_time)
		mat.set_shader_parameter("whiteout", size)
	hp -= amount
	hp_bar.value = hp

func use_stamina(stamina: float):
	stam_bar.value -= stamina
	stam_cd = stamina_regen_time

	
