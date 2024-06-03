extends Area3D

#positions of where the player will end up at after teleporting. can be changed for each teleporter
@export var exitpointx: float = 0
@export var exitpointy: float = 0
@export var exitpointz: float = 0


var xdifference: float = 0
var ydifference: float = 0
var zdifference: float = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#get the difference between teh exitpoint and teleporter position. This makes the teleportingg smoother
	xdifference = (exitpointx-position.x)
	ydifference = (exitpointy-position.y)
	zdifference = (exitpointz-position.z)

	print(xdifference)
	print(ydifference)
	print(zdifference)
