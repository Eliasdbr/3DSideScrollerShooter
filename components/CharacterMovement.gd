class_name CharacterMovement
extends Node



@onready var parent: CharacterBody3D = get_parent()

@export var acceleration: float = 10.0

@export var max_speed: float = 200.0

@export var damping: float = 0.2

@export var jumping_force: float = 200.0


var vel: Vector3 = Vector3.ZERO


func aim(direction: Vector2) -> void:
	pass

func move(direction: Vector2) -> void:
	vel.x += direction.x * acceleration
	clamp(vel.x, -max_speed, max_speed)

func jump() -> void:
	if parent.is_on_floor():
		vel = Vector3(vel.x, jumping_force, vel.z)

func shoot() -> void:
	pass


func _ready():
	pass

func _physics_process(delta):
	if parent.is_on_floor() and vel.y < 0.0:
		vel = Vector3(vel.x, 0, vel.z)
	else:
		vel += parent.get_gravity()
		
	parent.velocity = vel * delta
	parent.move_and_slide()
