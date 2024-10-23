extends CharacterBody3D


@export var SPEED = 7.5
const JUMP_VELOCITY = 5
var number_of_jumps = 0
@export var Jump_Buffer_Timer = 0.1

var _move_dir: Vector2 = Vector2.ZERO
var _rotation: float = 0
var turn_speed: float = 10

@export var x_spawn_position = 1
@export var y_spawn_position = 1
@export var z_spawn_position = 1

var Jump_Buffer:bool = false

@onready var all_interactions = []

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	pass

func _physics_process(delta):
	
	
	exacute_interaction()
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		if Jump_Buffer:
			Jump()
			Jump_Buffer = false

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept"):
		if number_of_jumps < 1:
			Jump()
		else:
			Jump_Buffer = true
			get_tree().create_timer(Jump_Buffer_Timer).timeout.connect(on_jump_buffer_timout)

	if is_on_floor():
		number_of_jumps *= 0

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("moveleft", "moveright", "moveup", "movedown")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	if Input.is_action_just_pressed("leftcamera"):
		$CameraController.rotation.y += PI/4
	if Input.is_action_just_pressed("rightcamera"):
		$CameraController.rotation.y -= PI/4
	
	#this is just to test if an input works. ui_text_sebmit
	if Input.is_action_pressed("ui_text_submit"):
		print("nada")
	
	self.rotation.y = $CameraController.rotation.y 
	
	move_and_slide()
	
	#make camera controller match the position of player
	#is below rest of physics process to make it smooth
	$CameraController.position = lerp($CameraController.position,position,1)
	

#########Intereaction Methods

#inputs interaction into list the player script can access
func _on_interaction_area_area_entered(area):
	all_interactions.insert(0, area)
	if area.is_in_group("teleport"):
		pass

#clears list
func _on_interaction_area_area_exited(area):
	all_interactions.erase(area)


#the different outcomes depending on the interaction area
func exacute_interaction():
	if all_interactions: 
		var cur_interation = all_interactions[0]
		match cur_interation.interact_type:
			"teleport" :  #use if where the player is teleporting from is static
				position.x += cur_interation.interact_value[0]
				position.y += cur_interation.interact_value[1]
				position.z += cur_interation.interact_value[2]
				$CameraController.position = lerp($CameraController.position,position,1)
			"unusualcamera" : #this is used for cases when I want thte camera to mess with the players vibe
				if is_on_floor():
					$CameraController/Camera_target/Camera3D.rotate_y(90)
			"slowcamera" : #uses to speed up the camera speed 
				$CameraController.position = lerp($CameraController.position,position,1)
			"moving_teleport" :  #use if where the player is teleporting from is moving
				position.x = cur_interation.interact_value[0]
				position.y = cur_interation.interact_value[1]
				position.z = cur_interation.interact_value[2]


func Jump()->void:
	velocity.y = JUMP_VELOCITY
	number_of_jumps += 1

func on_jump_buffer_timout()->void:
	Jump_Buffer = false

func _on_small_interaction_area_exited(area):
	if area.is_in_group("bounds"):
		position.x = x_spawn_position
		position.y = y_spawn_position
		position.z = z_spawn_position
