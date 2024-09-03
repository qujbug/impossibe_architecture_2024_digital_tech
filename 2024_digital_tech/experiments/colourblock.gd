extends Area3D

var colour = true
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if colour == true:
		$MeshInstance3D.transparency = 0.5
	else:
		$MeshInstance3D.transparency = 1


func _on_body_entered(body):
	if body.is_in_group("player"):
		if $MeshInstance3D.transparency == 0.5:
			$MeshInstance3D.transparency = 0
		if $MeshInstance3D.transparency == 0:
			$MeshInstance3D.transparency = 0.5
