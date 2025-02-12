extends CharacterBody2D

class_name HedgehogMob

@export var move_speed = 10
var direction: Vector2 = Vector2.RIGHT
@export var gravity = 4000
@export var direction_timeouts = [1, 2, 2.5]

@onready var animation_player = $AnimatedSprite2D

@onready var player = get_parent().get_node("Player")

@export var health = 1
@export var health_max = 100

@export var attack_range = 3
@export var can_see_below = false
@export var attack_damage = 10
@export var knockback_force = -20
@onready var raycast_floor_check_right = get_node("FloorCheckRight")
@onready var raycast_floor_check_left = get_node("FloorCheckLeft")

@export var despawn_if_skipped = false

@onready var vision_range = 288
@onready var raycast_line_of_sight = $LineOfSight
var can_see_player = false

enum MobState {ROAMING, AGGRO, ATTACK, HIT, DEAD}
var current_mob_state: MobState = MobState.ROAMING 

func _ready():
	player.connect("damage_dealt", Callable(self, "_took_damage"))


func _physics_process(delta):
	if !raycast_floor_check_left.is_colliding() && !raycast_floor_check_right.is_colliding():
		velocity.y += gravity * delta
	else:
		velocity.y = 0

	if current_mob_state == MobState.ROAMING:
		if raycast_floor_check_left.is_colliding() && !raycast_floor_check_right.is_colliding():
			direction = Vector2.LEFT
			$DirectionTimer.wait_time = direction_timeouts[randi_range(0, direction_timeouts.size() - 1)]
		elif !raycast_floor_check_left.is_colliding() && raycast_floor_check_right.is_colliding():
			direction = Vector2.RIGHT
			$DirectionTimer.wait_time = direction_timeouts[randi_range(0, direction_timeouts.size() - 1)]

	move()
	move_and_slide()

	if Engine.get_frames_drawn() % 1 == 0:
		if current_mob_state == MobState.AGGRO:
			var direction_to_player = (player.global_position - global_position).normalized()
			raycast_line_of_sight.target_position = direction_to_player * vision_range
			if raycast_line_of_sight.is_colliding():
				var collider = raycast_line_of_sight.get_collider()
				if collider == player:
					can_see_player = true
				else:
					can_see_player = false
			else:
				can_see_player = false


func _process(delta):
	handle_animations()
	print(current_mob_state)

func _on_hedgehog_mob_entered(body):
	set_mob_state(MobState.ATTACK)

func _on_aggro_radius_entered(body):
	if body.is_in_group("Player"):
		set_mob_state(MobState.AGGRO)
		$LineOfSightCheckTimer.start()

func _on_aggro_radius_exited(body):
	if body.is_in_group("Player"):
		if(current_mob_state == MobState.AGGRO):
			set_mob_state(MobState.ROAMING)
			$LineOfSightCheckTimer.stop()
			can_see_player = false
	
	if(despawn_if_skipped):
		$DespawnTimer.start()

func _took_damage(damage, body):
	if self == body and current_mob_state != MobState.DEAD:
		health -= damage
		set_mob_state(MobState.HIT)
		if health <= 0:
			health = 0
			set_mob_state(MobState.DEAD)

func _on_direction_timer_timeout():
	$DirectionTimer.wait_time = direction_timeouts[randi_range(0, direction_timeouts.size() - 1)]
	if current_mob_state != MobState.AGGRO:
		direction = [Vector2.RIGHT, Vector2.LEFT][randi_range(0, 1)]

func _on_despawn_timer_timeout():
	self.queue_free()

func set_mob_state(new_state: MobState):
	current_mob_state = new_state

func handle_animations():
	match current_mob_state:
		MobState.ROAMING:
			animation_player.play("Walk")
			if direction.x > 0:
				animation_player.flip_h = false
			elif direction.x < 0:
				animation_player.flip_h = true
		MobState.AGGRO:
			animation_player.play("Walk")
			if direction.x > 0:
				animation_player.flip_h = false
			elif direction.x < 0:
				animation_player.flip_h = true
		MobState.ATTACK:
			animation_player.play("Attack")
			player.damage(30)
			await get_tree().create_timer(1.5).timeout #Slower than using an existing node but for a demo it won't matter
		MobState.HIT:
			animation_player.play("Hit")
			await get_tree().create_timer(0.5).timeout
			set_mob_state(MobState.ROAMING)
		MobState.DEAD:
			animation_player.play("Dead")
			await get_tree().create_timer(1.0).timeout
			handle_death()

func handle_death():
	self.queue_free()

func move():
	if current_mob_state != MobState.DEAD:
		if current_mob_state != MobState.AGGRO:
			velocity = direction * move_speed
		elif current_mob_state == MobState.AGGRO and can_see_player:
			var direction_to_player = position.direction_to(player.position) * move_speed
			velocity.x = direction_to_player.x
			direction.x = abs(velocity.x) / velocity.x
		elif current_mob_state == MobState.HIT:
			var knockback_direction = position.direction_to(player.position) * knockback_force
			velocity.x = knockback_direction.x
	elif current_mob_state == MobState.DEAD:
		velocity.x = 0