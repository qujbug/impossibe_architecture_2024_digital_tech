extends State
class_name elephantidle

@export var move_speed = 10.0
@export var elephant : CharacterBody3D

var move_direction : Vector3
var wander_time : float 

func randomise_wander():
	move_direction = Vector3(randf_range(-1, 1), randf_range(-1, 1), randf_range(0,0)).normalized()
	wander_time = randf_range(1, 3)
	
func Enter():
	randomise_wander()
	
func Update(delta: float):
	if wander_time > 0:
		wander_time -= delta
		
	else:
		randomise_wander()
		
func physics_update(delta: float):
	if elephant:
		elephant.velocity = move_direction * move_speed
