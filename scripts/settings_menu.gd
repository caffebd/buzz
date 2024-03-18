extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	match GlobalVars.difficulty_level:
		0:
			%NormalBtn.button_pressed = false
			%HardBtn.button_pressed = false
			%RelaxedBtn.button_pressed = true
		1:
			%NormalBtn.button_pressed = true
			%HardBtn.button_pressed = false
			%RelaxedBtn.button_pressed = false
		2:
			%NormalBtn.button_pressed = false
			%HardBtn.button_pressed = true
			%RelaxedBtn.button_pressed = false






func _on_relaxed_btn_pressed() -> void:
	%NormalBtn.button_pressed = false
	%HardBtn.button_pressed = false
	%RelaxedBtn.button_pressed = true
	GlobalVars.difficulty_level = 0
	SaveLoad.save_data()
	


func _on_normal_btn_pressed() -> void:
	%NormalBtn.button_pressed = true
	%HardBtn.button_pressed = false
	%RelaxedBtn.button_pressed = false
	GlobalVars.difficulty_level = 1
	SaveLoad.save_data()


func _on_hard_btn_pressed() -> void:
	%NormalBtn.button_pressed = false
	%HardBtn.button_pressed = true
	%RelaxedBtn.button_pressed = false
	GlobalVars.difficulty_level = 2
	SaveLoad.save_data()

func _on_back_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
