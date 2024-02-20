extends Control

var secret_area_count:int = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if GlobalVars.secret_room_found:
		secret_area_count += 1
	if GlobalVars.secret_area_found:
		secret_area_count += 1
	%SecretAreaFound.text = "Secret Areas Found = "+str(secret_area_count)+"/2"

# Called every frame. 'delta' is the elapsed time since the previous frame.


func _on_replay_btn_pressed():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	get_tree().change_scene_to_file("res://theCave.tscn")
