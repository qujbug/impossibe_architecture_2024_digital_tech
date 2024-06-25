extends CharacterBody3D


@export var SPEED = 7.5
const JUMP_VELOCITY = 10
var number_of_jumps = 0

var _move_dir: Vector2 = Vector2.ZERO
var _rotation: float = 0
var turn_speed: float = 10

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

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and number_of_jumps < 1:
		velocity.y = JUMP_VELOCITY
		number_of_jumps += 1

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
	
	##############DELETEAFTERPROTOTYPE##############
	if Input.is_action_pressed("escape"):
		get_tree().change_scene_to_file("res://checkpoints/prototype.tscn")
	

#########Intereaction Methods

func _on_interaction_area_area_entered(area):
	all_interactions.insert(0, area)
	if area.is_in_group("teleport"):
		pass


func _on_interaction_area_area_exited(area):
	all_interactions.erase(area)



func exacute_interaction( ):
	if all_interactions: 
		var cur_interation = all_interactions[0]
		match cur_interation.interact_type:
			"teleport" : 
				position.x += cur_interation.interact_value[0]
				position.y += cur_interation.interact_value[1]
				position.z += cur_interation.interact_value[2]
				$CameraController.position = lerp($CameraController.position,position,1)
			"unusualcamera" :
				if is_on_floor():
					$CameraController/Camera_target/Camera3D.rotate_y(90)
			"slowcamera" :
				$CameraController.position = lerp($CameraController.position,position,1)


func _on_area_3d_area_entered(area):
	if is_in_group("water"):
		velocity.y *= 0.125
		if Input.is_action_pressed("swimup"):
			velocity.y += SPEED
		if Input.is_action_pressed("swimdown"):
			velocity.y -= SPEED
		
