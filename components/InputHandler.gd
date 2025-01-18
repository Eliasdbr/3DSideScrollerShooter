class_name InputHandler
extends Node

@export var movement_component: CharacterMovement

func _physics_process(delta):
	# Aims the player
	var aim_vector = Input.get_vector("Left", "Right", "Down", "Up", 0.25)
	if aim_vector.length() > 0.25:
		movement_component.aim(aim_vector)
	
	# Moves the player
	var move_dir = Input.get_axis("Left", "Right")
	movement_component.move(Vector2(move_dir, 0.0))
	
	# Jump Action
	if Input.is_action_just_pressed("Jump"):
		movement_component.jump()
	
	# Shoot Action
	if Input.is_action_pressed("Shoot"):
		movement_component.shoot()
