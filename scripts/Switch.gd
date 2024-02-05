extends Node3D


@export var linked_object:Node3D

@export var the_player: CharacterBody3D

@export var switch_on:=false

# Called when the node enters the scene tree for the first time.
func _ready():

	if not switch_on:
		%SwitchAnim.play("already_off")
		switch_on=false
	else:
		%SwitchAnim.play("already_on")
		switch_on=true


func use_action(player):
	if %SwitchAnim.is_playing():
		return
	if !switch_on:
		switch_on = true
		%SwitchAnim.play("on")
		%RedLight.visible = false
		if linked_object != null:
			linked_object.linked_action()
		#if GlobalVars.tape_current_state == GlobalVars.TapeStates.lever:
			#CameraTransition.transition_camera3D( the_player.camera,$LeverCam, 0.8)
			#var yield_timer_a = Timer.new()
			#add_child(yield_timer_a)
			#yield_timer_a.start(0.9);
			#await yield_timer_a.timeout
	else:
		switch_on = false
		%SwitchAnim.play("off")
		%RedLight.visible = true
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
		




