extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SaveLoad.load_data()
	%PlayPop.visible = false



func _on_play_btn_pressed() -> void:
	%PlayPop.visible = true
	if GlobalVars.check_point > 0:
		%ContinueBtn.disabled = false
	else:
		%ContinueBtn.disabled = true

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		%PlayPop.visible = false


func _on_new_game_btn_pressed() -> void:
	GlobalVars.check_point = 0
	GlobalVars.secret_room_found = false
	GlobalVars.secret_area_found = false
	GlobalVars.sneaky_wall_open = false
	await SaveLoad.save_data()
	get_tree().change_scene_to_file("res://scenes/intro.tscn")


func _on_continue_btn_pressed() -> void:
	await SaveLoad.load_data()
	get_tree().change_scene_to_file("res://theCave.tscn")


func _on_settings_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/settings_menu.tscn")


func _on_exit_btn_pressed() -> void:
	get_tree().quit()
