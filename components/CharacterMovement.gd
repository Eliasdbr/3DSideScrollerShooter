class_name CharacterMovement
extends Node

# MARK: variables

@onready var parent: CharacterBody3D = get_parent()
@export var collision_shape: CollisionShape3D
@export var model_pivot: Node3D

@export var acceleration: float = 24.0

@export var max_speed: float = 320.0

@export var damping: float = 48.0

@export var jumping_force: float = 240.0

@export var collision_height: float = 1.75


var vel: Vector3 = Vector3.ZERO
var is_crouching: bool = false

func aim(direction: Vector2) -> void:
	pass

func move(direction: Vector2) -> void:
	DebugUI.updateValue("XDir", direction.x)
	if direction.x == 0.0:
		if vel.x != 0:
			# Movement damping
			if parent.is_on_floor():
				vel.x -= sign(vel.x) * damping
			else:
				# Less friction on air
				vel.x -= sign(vel.x) * (damping * 0.1)
			# Prevent drifting
			if abs(vel.x) <= damping:
				vel.x = 0
	else:
		#if abs(vel.x) < max_speed:
		# Accelerates
		if sign(direction.x) == sign(vel.x):
			vel.x += direction.x * acceleration
		else:
			# Suddenly changes direction
			if parent.is_on_floor():
				vel.x += direction.x * acceleration * 2
			else:
				vel.x += direction.x * acceleration * 0.5
	# Speed limit
	var max_s = max_speed 
	if is_crouching == true: 
		max_s = max_speed*0.5
	
	if abs(vel.x) >= max_s:
		vel.x = max_s * sign(vel.x)
	

func jump() -> void:
	if parent.is_on_floor():
		vel = Vector3(vel.x, jumping_force, vel.z)

func shoot() -> void:
	pass

func crouch() -> void:
	is_crouching = !is_crouching
	
	if collision_shape:
		var coll_shape = collision_shape.shape as CapsuleShape3D
		if is_crouching:
			coll_shape.height = collision_height * 0.5
			collision_shape.position.y = collision_height * 0.25
		else:
			coll_shape.height = collision_height
			collision_shape.position.y = collision_height * 0.5



func _ready():
	DebugUI.addValue("XVel", vel.x)
	DebugUI.addValue("XDir", 0)

func _physics_process(delta):
	# Gravity
	if parent.is_on_floor() and vel.y < 0.0:
		vel = Vector3(vel.x, 0, vel.z)
	else:
		vel += parent.get_gravity()
		
	DebugUI.updateValue("XVel", vel.x)
		
	parent.velocity = vel * delta
	parent.move_and_slide()
