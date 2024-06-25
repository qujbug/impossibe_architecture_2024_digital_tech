extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$Label.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("escape"):
		$Label.hide()
		$VBoxContainer.show()


func _on_teleporter_pressed():
	get_tree().change_scene_to_file("res://level_1.tscn")


func _on_exit_pressed():
	get_tree().quit()


func _on_notes_pressed():
	$Label.show()
	$VBoxContainer.hide()
