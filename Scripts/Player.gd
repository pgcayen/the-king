extends CharacterBody2D

@export var speed = 100.0
@export var jump_height = -300.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_attacking = false
var is_climbing = false

# TODO: Put all this in git before next tutorial

func _physics_process(delta):	
	if is_climbing == true:
		if Input.is_action_pressed("ui_up"):
			$AnimatedSprite2D.play("climb")
			gravity = 100
			velocity.y = -200
	else:
		gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
		is_climbing = false
	
	# Add the gravity
	if !is_on_floor():
		velocity.y += gravity * delta
	
	# Get the input direction and handle the movement/deceleration
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()
	if !is_attacking:
		player_animations()	
	
func player_animations():
	# if the character is climbing or jumping
	# don't change current animation
	if !is_on_floor():
		pass
	
	if Input.is_action_pressed("ui_left"):
		$AnimatedSprite2D.flip_h = true
		$AnimatedSprite2D.play("run")
		$CollisionShape2D.position.x = 7
		
	if Input.is_action_pressed("ui_right"):
		$AnimatedSprite2D.flip_h = false
		$AnimatedSprite2D.play("run")
		# offset due to sprite being unaligned
		$CollisionShape2D.position.x = -7	

	if !Input.is_anything_pressed():
		$AnimatedSprite2D.play("idle")

func _input(event):
	if event.is_action_pressed("ui_attack"):
		is_attacking = true
		$AnimatedSprite2D.play("attack")
			
	if event.is_action_pressed("ui_jump") && is_on_floor():
		velocity.y = jump_height
		$AnimatedSprite2D.play("jump")

# signal that waits 
func _on_animated_sprite_2d_animation_finished():
	is_attacking = false
