extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
var number_of_jumps = 0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	pass

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and number_of_jumps < 2:
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

	direction = Vector3(Input.get_action_strength("moveleft") - Input.get_action_strength("moveright"),
	0,
	Input.get_action_strength("moveup") - Input.get_action_strength("movedown"))
	camera()

	#this is just to test if an input works. ui_text_sebmit
	if Input.is_action_pressed("ui_text_submit"):
		print("nada")
		
	move_and_slide()


#interaction methods
func _on_area_3d_area_entered(area):
	##iinteracting by teleporting
	if area.is_in_group("teleporter-enter"):
		position.x += 25
		position.y += 25
		position.z += 25
	
func camera():
	if Input.is_action_pressed("rightcamera"):
		$Camera3d.rotate.x += 90
	if Input.is_action_pressed("leftcamera"):
		$Camera3D.rotate.x += 90
