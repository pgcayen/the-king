extends CharacterBody2D

@export var speed = 100.0
@export var jump_height = -300.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):	
	if Global.is_climbing == true:	
		if !is_on_floor():
			Global.is_attacking = false
			$AnimatedSprite2D.play("climb")	
		
		if Input.is_action_pressed("ui_up"):
			velocity.y = -100
		else:
			velocity.y = 35

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
	
	# if the character is climbing, jumping or attacking
	# don't change current animation
	if !Global.is_attacking && is_on_floor():
		player_animations()	
	
func player_animations():	
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
		Global.is_attacking = true
		$AnimatedSprite2D.play("attack")
			
	if event.is_action_pressed("ui_jump") && is_on_floor():
		velocity.y = jump_height
		if !Global.is_attacking:
			$AnimatedSprite2D.play("jump")	

# signal that waits 
func _on_animated_sprite_2d_animation_finished():
	Global.is_attacking = false
	Global.is_climbing = false

