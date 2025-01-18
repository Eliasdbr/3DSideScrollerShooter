class_name CharacterMovement
extends Node


@onready var parent: CharacterBody3D = get_parent()

@export var acceleration: float = 24.0

@export var max_speed: float = 320.0

@export var damping: float = 48.0

@export var jumping_force: float = 240.0


var vel: Vector3 = Vector3.ZERO


func aim(direction: Vector2) -> void:
	pass

func move(direction: Vector2) -> void:
	if (
		direction.length() == 0.0 
		and abs(vel.x) > 0
	):
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
		# Accelerates
		if abs(vel.x) < max_speed:
			if sign(direction.x) <= 0:
				vel.x += direction.x * acceleration
			else:
				# Suddenly changes direction
				vel.x += direction.x * acceleration * 2
	
	clamp(vel.x, -max_speed, max_speed)


func jump() -> void:
	if parent.is_on_floor():
		vel = Vector3(vel.x, jumping_force, vel.z)

func shoot() -> void:
	pass


func _ready():
	pass

func _physics_process(delta):
	# Gravity
	if parent.is_on_floor() and vel.y < 0.0:
		vel = Vector3(vel.x, 0, vel.z)
	else:
		vel += parent.get_gravity()
		
	parent.velocity = vel * delta
	parent.move_and_slide()
