extends Node3D


@export var linked_object:Node3D

@export var the_player: CharacterBody3D

@export var lever_on:=false

# Called when the node enters the scene tree for the first time.
func _ready():

	if not lever_on:
		%LeverAnim.play("already_off")
		lever_on=false
	else:
		%LeverAnim.play("already_on")
		lever_on=true


func use_action(player):
	if %LeverAnim.is_playing():
		return
	if !lever_on:
		lever_on = true
		%LeverAnim.play("on")
		GlobalVars.lever_state = "on"
		#if GlobalVars.tape_current_state == GlobalVars.TapeStates.lever:
			#CameraTransition.transition_camera3D( the_player.camera,$LeverCam, 0.8)
			#var yield_timer_a = Timer.new()
			#add_child(yield_timer_a)
			#yield_timer_a.start(0.9);
			#await yield_timer_a.timeout
		if linked_object != null:
			linked_object.linked_action()
	#else:
		#
		#lever_anim.play("off")
		#GlobalVars.lever_state = "off"
		##if GlobalVars.tape_current_state == GlobalVars.TapeStates.lever:
			##CameraTransition.transition_camera3D( the_player.camera,$LeverCam, 0.8)
			##var yield_timer_a = Timer.new()
			##add_child(yield_timer_a)
			##yield_timer_a.start(0.9);
			##await yield_timer_a.timeout
		#if linked_object != null:
			#linked_object.linked_action()
		




