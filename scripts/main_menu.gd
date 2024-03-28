extends Control

var cheat_code: Array[String] = ["l","e","t","m","e","c","h","e","a","t"]
var cheat_index: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	%PlayPop.visible = false
	%Rewardpop.visible = false
	$RewardBtn.visible = false
	_setup_reward()

func _setup_reward():
	await SaveLoad.load_data()
	if GlobalVars.reward_unlocked:
		$RewardBtn.visible = true
		%BestTime.text = str(GlobalVars.reward_time)+" seconds"
		
func _on_play_btn_pressed() -> void:
	%PlayPop.visible = true
	%ExitBtn.visible = false
	%ExitBtn.disabled = true
	print (GlobalVars.secret_area_found)
	print (GlobalVars.secret_room_found)
	if GlobalVars.check_point > 0:
		%ContinueBtn.disabled = false
	else:
		%ContinueBtn.disabled = true

func _unhandled_input(event: InputEvent) -> void:
	return
	#if event is InputEventMouseButton:
		#%PlayPop.visible = false
		#%Rewardpop.visible = false


func _on_new_game_btn_pressed() -> void:
	GlobalVars.check_point = 0
	GlobalVars.encounters = 0
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


func _on_reward_btn_pressed() -> void:
	%Rewardpop.visible = true


func _on_play_reward_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/reward_scene.tscn")


func _unhandled_key_input(event: InputEvent) -> void:
	if $RewardBtn.visible:
		return
	if event is InputEventKey:
		if event.is_pressed():
			var character = char(event.unicode).to_lower()
			#print (character)
			if character== cheat_code[cheat_index]:
				cheat_index += 1
				if cheat_index >= cheat_code.size():
					print ("CHEATER")
					%CheatAudio.play()
					cheat_index = 0
					$RewardBtn.visible = true
					%BestTime.text = str(GlobalVars.reward_time)+" seconds"
			else:
				cheat_index = 0





func _on_back_btn_pressed() -> void:
	%ExitBtn.visible = true
	%ExitBtn.disabled = false
	%PlayPop.visible = false
	%Rewardpop.visible = false


func _on_credits_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/credits_menu.tscn")
