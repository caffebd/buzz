extends Node3D

var secret_area_count:int = 0
var assessment: String
var result: String
var countdown: int = 5

@export var player: CharacterBody3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%CountDownLabel.text = str(countdown)
	%CountDownLabel.visible = false
	GlobalVars.in_lift = false
	player.set_start_position(player.global_position, deg_to_rad(180.0))
	_setup_signs()


func _setup_signs():
	if GlobalVars.secret_room_found:
		secret_area_count += 1
	if GlobalVars.secret_area_found:
		secret_area_count += 1
	$SecretSign3/Label3D.text = "Secret Areas found "+ str(secret_area_count)+"/2"
	$SecretSign4/Label3D.text = str(GlobalVars.encounters) + " Anomaly Encounters"

	if GlobalVars.encounters < 10:
		assessment = "LOW"
	elif GlobalVars.encounters < 15:
		assessment = "MEDIUM"
	else:
		assessment = "HIGH"

	$SecretSign5/Label3D.text = "Encounter Rate "+ assessment

	if assessment == "LOW" and secret_area_count == 2:
		result = "REWARD"
		GlobalVars.reward_unlocked = true
	elif assessment == "LOW" and not secret_area_count == 2:
		result = "RE-TRAIN"
	elif assessment == "MEDIUM":
		result = "RE-TRAIN"
	else:
		result = "TERMINATION"
	
	SaveLoad.save_data()

	%RecLabel.text = result
# Called every frame. 'delta' is the elapsed time since the previous frame.



func _on_end_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		call_deferred("_disable_col")
		%CountDownLabel.visible = true
		%EndTimer.start()


func _disable_col():
	$End/EndCol.disabled = true

func _on_kill_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		get_tree().quit()


func _on_end_timer_timeout() -> void:
	countdown -= 1
	%CountDownLabel.text = str(countdown)
	if countdown == 0:
		%EndTimer.stop
		match result:
			"TERMINATION":
				$IntroPath/StaticBody3D/PathColl.disabled = true
			"RE-TRAIN":
				get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
			"REWARD":
				get_tree().change_scene_to_file("res://scenes/reward_scene.tscn")
